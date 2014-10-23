Pod::Spec.new do |s|
    s.name         = 'DDGFoundation'
    s.version      = '1.0'
    s.license      = 'MIT'

    s.summary      = 'Foundation'
    s.homepage     = 'https://dudagroup.com'
    s.author       = { 'Till Hagger' => 'till.hagger@gmail.com' }

    s.source       = { :git => 'https://github.com/dudagroup/DDGFoundation', :tag => '1.0' }
    s.platform     = :ios, '7.0'
    s.source_files = 'src/DDGFoundation.h'

    s.framework    = 'UIKit'
    s.requires_arc = true

    s.subspec 'Utility' do |sp|
        sp.source_files = 'src/util/*.{h,m}'
        sp.prefix_header_contents = '#define DDG_FOUNDATION_UTILITY_ENABLED'
    end

    s.subspec 'Additions' do |sp|
        sp.source_files = 'src/additions/*.{h,m}'
        sp.prefix_header_contents = '#define DDG_FOUNDATION_ADDITIONS_ENABLED'
    end

    s.subspec 'PotentiallyDangerousAdditions' do |sp|
        sp.source_files = 'src/potentially_dangerous_additions/*.{h,m}'
        sp.prefix_header_contents = '#define DDG_FOUNDATION_POTENTIALLY_DANGEROUS_ADDITIONS_ENABLED'
    end

    s.subspec 'ImageQueue' do |sp|
        sp.dependency 'AFNetworking', '~> 2.4'
        sp.source_files = 'src/image_queue/*.{h,m}'
        sp.prefix_header_contents = '#define DDG_FOUNDATION_IMAGE_QUEUE_ENABLED'
    end
end
