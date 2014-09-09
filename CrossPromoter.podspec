Pod::Spec.new do |spec|
#Information
  spec.name         = 'CrossPromoter'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/mergesort/CrossPromoter'
  spec.author       =  { 'Joe Fabisevich' => 'github@fabisevi.ch' }
  spec.summary      = "A framework for showing other apps that you own, in the form of a banner and interstitial. It allows a user to open and download an app without leaving your app."
  spec.source       =  { :git => 'https://github.com/mergesort/CrossPromoter.git', :tag => "#{spec.version}" }
  spec.source_files = 'src/*.{h,m}'
  spec.framework    = 'Foundation'
  spec.requires_arc = true
  spec.social_media_url = 'https://twitter.com/mergesort'
  spec.ios.deployment_target = '7.0'

#Depdencies
  spec.dependency 'PureLayout'
end
