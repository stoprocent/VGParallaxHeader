Pod::Spec.new do |s|
    s.name         = 'VGParallaxHeader'
    s.version      = '0.0.3'
    s.platform     = :ios, '7.0'
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    s.summary      = 'Only Parallax Header Class that should work with all kinds of Table Views and Scroll Views while using Auto Layout.'
    s.homepage     = 'https://github.com/stoprocent/VGParallaxHeader'
    s.author       = { 'Marek Serafin' => 'marek@snowheads.pl' }
    s.source       = { :git => 'https://github.com/stoprocent/VGParallaxHeader.git', :tag => 'v0.0.3' }
    s.description  = 'Only Parallax Header Class that should work with all kinds of Table Views (Including usage of Section Headers) and Scroll Views while using Auto Layout.'
    s.frameworks   = 'QuartzCore'
    s.source_files = 'VGParallaxHeader/*.{h,m}'
    s.dependency 'PureLayout'
    s.requires_arc = true
end