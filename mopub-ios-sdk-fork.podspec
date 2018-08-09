Pod::Spec.new do |spec|
    spec.name = 'mopub-ios-sdk-fork'
    spec.version = '1.0.0'
    spec.summary = 'Fork of ios sdk'
    spec.homepage = 'https://github.com/voytov1ch/mopub-ios-sdk'
    spec.license = { :type => 'MIT', :file => 'LICENSE' }
    spec.author = { 'Igor Voytovich' => 'igor.voytovich@gen.tech' }
    spec.social_media_url = ''
    spec.source = { :git => 'https://github.com/voytov1ch/mopub-ios-sdk.git', :tag => "#{spec.version}" }
    spec.source_files = 'MoPubSDK/*.{h,m}'
    spec.ios.deployment_target = '8.0'
    spec.requires_arc = true
end