Pod::Spec.new do |spec|
  spec.name         = 'RCRefreshControl'
  spec.version      = '0.0.1'
  spec.summary      = 'Simple Refresh Control.'
  spec.description  = 'Simple Refresh Control Framework.'
  spec.homepage     = 'https://github.com/c0ming/RCRefreshControl'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { 'c0ming' => 'https://github.com/c0ming' }
  spec.platform = :ios, '7.0'
  spec.source = { :git => 'https://github.com/c0ming/KSToastView.git', :tag => 'v0.0.1' }
  spec.source_files  = 'RCRefreshControl/*.{h,m}'
  spec.framework = 'QuartzCore'
  spec.requires_arc = true
end
