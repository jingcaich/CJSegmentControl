Pod::Spec.new do |s|
  s.name         = 'CJSegmentControl'
  s.summary      = 'A segmentControl like weibo using.'
  s.version      = '1.0.1'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'jingcaich' => 'jingcaich@gmail.com' }
  s.social_media_url = 'http://s.weibo.com/weibo/_Edward__C&Refer=STopic_box'
  s.homepage     = 'https://github.com/jingcaich/WeiBo-Segment-Control'
  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.source       = { :git => 'https://github.com/jingcaich/WeiBo-Segment-Control.git', :tag => s.version.to_s }
  
  s.requires_arc = true
  s.source_files = 'CJSegmentControl/*.{h,m}'
  s.public_header_files = 'CJSegmentControl/*.{h}'

  s.frameworks = 'UIKit'

end
