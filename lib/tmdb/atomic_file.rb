# frozen_string_literal: true

require "tempfile"

module TMDb
  module AtomicFile
    module_function

    # Keep the old file until the complete replacement is ready. The temporary
    # file must be on the same filesystem for File.rename to be atomic.
    def write(path, content)
      # Replace the file a symlink points to, not the symlink itself.
      destination = (File.exist?(path) || File.symlink?(path)) ? File.realpath(path) : File.expand_path(path)
      mode = File.exist?(destination) ? File.stat(destination).mode & 0o777 : 0o666 & ~File.umask

      Tempfile.create([".#{File.basename(destination)}", ".tmp"], File.dirname(destination)) do |temporary|
        temporary.binmode
        temporary.write(content)
        temporary.flush
        temporary.fsync
        temporary.chmod(mode)
        temporary.close
        File.rename(temporary.path, destination)
      end
    end
  end
end
