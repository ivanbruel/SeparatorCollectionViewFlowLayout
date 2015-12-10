Pod::Spec.new do |s|
  s.name         = "SeparatorCollectionViewFlowLayout"
  s.version      = "1.0.3"
  s.summary      = "A UICollectionViewFlowLayout implementation to allow separators between cells"
  s.description  = <<-EOS
  A UICollectionViewFlowLayout implementation to allow separators between cells
  with a custom separator color and width.
  Instructions on how to use it are in
  [the README](https://github.com/ivanbruel/SeparatorCollectionViewFlowLayout).
  EOS
  s.homepage     = "https://github.com/ivanbruel/SeparatorCollectionViewFlowLayout"
  s.license      = { :type => "MIT", :file => "License" }
  s.author             = { "Ivan Bruel" => "ivan.bruel@gmail.com" }
  s.social_media_url   = "http://twitter.com/ivanbruel"
  s.ios.deployment_target = '8.0'
  s.source       = { :git => "https://github.com/ivanbruel/SeparatorCollectionViewFlowLayout.git", :tag => s.version }
  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files  = "Source/*.swift"
    ss.framework  = "Foundation"
    ss.framework  = "UIKit"
  end

end
