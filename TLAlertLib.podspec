
Pod::Spec.new do |s|
  s.name         = 'TLAlertLib'
  s.version      = '1.0.3'
  s.license      = 'MIT'
  s.ios.deployment_target = '9.0'
  s.platform     = :ios, '9.0'
  s.summary      = '高仿UIAlertController'
  s.homepage     = 'https://github.com/LoongerTao/TLAlertController'
  s.author       = { 'LoongerTao' => '495285195@qq.com' }
  s.requires_arc = true
  s.source       = { :git => 'https://github.com/LoongerTao/TLAlertController.git', :tag => s.version }
  s.source_files = 'TLAlertController/TLAlertLib/*.{h,m}'
end


# 错误：xcodebuild: Returned an unsuccessful exit code. 
# 一般是有头文件相互依赖，pod检测通不过


# [!] There was an error pushing a new version to trunk: execution expired
# 网络问题，更换网络

