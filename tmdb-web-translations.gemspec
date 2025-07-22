# frozen_string_literal: true

require_relative 'lib/tmdb/web/translations/version'

Gem::Specification.new do |spec|
  spec.name          = 'tmdb-web-translations'
  spec.version       = TMDb::Web::Translations::VERSION
  spec.authors       = ['Travis Bell']
  spec.email         = ['travis@themoviedb.org']

  spec.summary       = "TMDB's web translation library."
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('i18n')
end
