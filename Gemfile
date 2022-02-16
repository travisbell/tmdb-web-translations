# frozen_string_literal: true

source "https://rubygems.org"

if Bundler.settings["local"] == "true"
  shared = { :path => "/workspace/tmdb-shared" }
else
  shared = { :git => "git@github.com:tivocorp/tmdb-shared.git" }
end

# Specify your gem's dependencies in tmdb-youtube.gemspec
gemspec

gem "rake", "~> 13.0"
gem "rubocop", "~> 1.7"
gem "shared", shared