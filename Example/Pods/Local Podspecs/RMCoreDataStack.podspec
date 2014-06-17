Pod::Spec.new do |s|
  s.name             = "RMCoreDataStack"
  s.version          = begin; File.read('VERSION'); rescue; '9000.0.0'; end
  s.summary          = "Hit the ground running with a sane Core Data stack."
  s.description      = <<-DESC
                       Hit the ground running with a sane Core Data stack.

                       * Sensible defaults and easy configuration
                       * iCloud sync made easy when you want it
                       DESC
  s.homepage         = "http://robmaceachern.github.io/RMCoreDataStack"
  s.license          = 'MIT'
  s.author           = { "Rob MacEachern" => "rob@robmaceachern.com" }
  s.source           = { :git => "https://github.com/robmaceachern/RMCoreDataStack.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/robmaceachern'

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.source_files = 'Classes', 'Classes/**/*.{h,m}'
  s.frameworks = 'CoreData'
end
