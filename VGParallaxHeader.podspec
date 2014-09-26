Pod::Spec.new do |s|
	s.name = 'VGParallaxHeader'
	s.version = '0.0.1'
	s.platform = :ios, '7.0'
	s.license = 'MIT'
	s.summary = 'Only Parallax Header Class that should work with all kinds of Table Views and Scroll Views.'
	s.homepage = 'https://github.com/stoprocent/VGParallaxHeader'
	s.author = { 'Marek Serafin' => 'marek@snowheads.pl' }
	s.source = { :git => 'https://github.com/stoprocent/VGParallaxHeader.git' }
	s.description = 'Only Parallax Header Class that should work with all kinds of Table Views and Scroll Views.'
	s.frameworks = 'QuartzCore'
	s.source_files = 'VGParallaxHeader/*.{h,m}'
	s.dependency 'PureLayout'
	s.requires_arc = true
end