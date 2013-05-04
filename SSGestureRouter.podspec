Pod::Spec.new do |s|
  s.platform     = :ios, '5.0'
  s.name         = 'SSGestureRouter'
  s.version      = '0.0.1'
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/sandalsoft/SSXGestureRouter'
  s.authors      = { 'Eric Nelson' => '@sandalsoft' }
  s.summary      = 'Objective-C library to read complex touch gestures and perform an action. '
  s.source       =  {
                      :git => 'https://github.com/sandalsoft/SSGestureRouter.git', 
                      :tag=> s.version.to_s
					}  
  s.source_files = 'SSGestureRouter/*.{h,m}'
  s.framework    = 'QuartzCore'
  s.requires_arc = true
end
