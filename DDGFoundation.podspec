Pod::Spec.new do |s|
    s.name         = "DDGFoundation"
    s.version      = "1.0"
    s.license      = "MIT"

    s.summary      = "Foundation"
    s.homepage     = "https://dudagroup.com"
    s.author       = { "Till Hagger" => "till.hagger@gmail.com" }

    s.source       = { :git => "https://github.com/dudagroup/DDGFoundation", :tag => "1.0" }
    s.platform     = :ios, '6.0'
    s.source_files = 'src/*.{h,m}', 'src/**/*.{h,m}'

    s.framework    = 'UIKit'
    s.requires_arc = true
end
