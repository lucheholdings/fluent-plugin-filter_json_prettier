lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fluent/plugin/filter_json_prettier/version"

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-filter_json_prettier"
  spec.version       = Fluent::Plugin::FilterJsonPrettier::VERSION
  spec.authors       = ["LUCHE HOLDINGS PTE. LTD."]
  spec.email         = ["info@bestpresent.jp"]

  spec.summary       = "transform entries of a record to pretty JSON string safely"
  spec.description   = "JSON prettier with yajl-ruby to avoid 'error = \\xXX from ASCII-8BIT to UTF-8'"
  spec.homepage      = "https://github.com/lucheholdings/fluent-plugin-filter_json_prettier"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://example.com/donotpush"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "test-unit"

  spec.add_runtime_dependency "fluentd", ">= 1.0.2"
  spec.add_runtime_dependency "yajl-ruby", "~> 1.3.1"
end
