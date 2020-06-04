Pod::Spec.new do |spec|
  spec.name         = 'Hyphenate_VideoRecoder'
  spec.version      = '3.3.2'
  spec.license       = { :type => 'Copyright', :text => 'EaseMob Inc. 2017' }
  spec.summary      = 'EaseMob UI Kit'
  spec.homepage     = 'https://www.easemob.com'
  spec.author       = {'EaseMob Inc.' => 'admin@easemob.com'}
  spec.source       =  {:path => './' }
  spec.source_files = '**/*.{h,m,mm}'
  spec.platform     = :ios, '8.0'
  spec.vendored_libraries = ['HyphenateVideoRecorderPlugin/libHyphenateAVRecorder-universal.a','HyphenateVideoRecorderPlugin/libffmpeg-ios-full.a']
  spec.requires_arc = true
  spec.libraries    = 'bz2', 'z', 'iconv', 'c++'
end
