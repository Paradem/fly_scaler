# frozen_string_literal: true

require_relative "lib/fly_scaler/version"

Gem::Specification.new do |spec|
  spec.name = "fly_scaler"
  spec.version = FlyScaler::VERSION
  spec.authors = ["psguazz"]
  spec.email = ["p.sguazz@gmail.com"]

  spec.summary = "Scaling job machines up and down autoatically on Fly.io"
  spec.homepage = "https://github.com/Paradem/fly_scaler"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Paradem/fly_scaler"
  spec.metadata["changelog_uri"] = "https://github.com/Paradem/fly_scaler/blob/main/README.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  spec.add_dependency "httparty"

  spec.add_development_dependency("mocktail")

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
