Pod::Spec.new do |s|
  s.name             = "RMCoreDataStack"
  s.version          = "0.1.0"
  s.summary          = "Hit the ground running with a simple Core Data stack."
  s.description      = <<-DESC
                       Hit the ground running with a simple Core Data stack.

                       * Sensible defaults and easy configuration
                       * iCloud sync made easy
                       DESC
  s.homepage         = "http://www.robmaceachern.com"
  s.license          = 'MIT'
  s.author           = { "Rob MacEachern" => "rob@robmaceachern.com" }
  s.source           = { :git => "https://github.com/robmaceachern/RMCoreDataStack.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/robmaceachern'

  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.source_files = 'Classes'
  s.resources = 'Assets/*.png'
  s.frameworks = 'CoreData'
end
