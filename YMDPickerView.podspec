Pod::Spec.new do |s|
  s.name         = "YMDPickerView"
  s.version      = "0.1"
  s.summary      = "Custom DatePickerView, only show the selected Date years"
  s.homepage     = "https://github.com/xiekunRonaldo/YMDPickerView"

  s.license      = 'MIT'
  s.author       = { "allenToFight" => "dreamerxiekun@gmail.com" }

  s.platform     = :ios, '6.0'
  s.source       = { :git => "git@github.com:xiekunRonaldo/YMDPickerView.git", :tag => "0.1" }
  s.source_files = 'YMDPickerView', 'YMDPickerView/*.{h,m}'
  s.requires_arc = true
end