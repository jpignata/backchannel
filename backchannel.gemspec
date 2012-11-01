Gem::Specification.new do |spec|
  spec.name          = "backchannel"
  spec.version       = "0.1.1"
  spec.platform      = Gem::Platform::RUBY
  spec.license       = "MIT"
  spec.authors       = ["John Pignata"]
  spec.email         = ["john@pignata.com"]
  spec.summary       = "Sample application from article posted on http://tx.pignata.com"
  spec.description   = "Multicast-based peer-to-peer text chat"
  spec.files         = `git ls-files`.split("\n")
  spec.executables   = %w(backchannel)
  spec.require_paths = ["lib"]
  spec.homepage      = "https://github.com/jpignata/backchannel"

  spec.required_ruby_version = ">= 1.9.3"
end
