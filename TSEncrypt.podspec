#
#  Be sure to run `pod spec lint TSUtility.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#
Pod::Spec.new do |s|
  s.name         = "TSEncrypt"
  s.version      = "1.0.0"
  s.summary      = "encrypt for string"
  s.description  = <<-DESC
                   加密工具类. 支持(AES RSA Base64 MD5 Url)
                   DESC
  s.platform     = :ios, "9.0"
  s.homepage     = "https://baidu.com"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "yuchenH" => "huangyuchen@caiqr.com" }
 

  s.swift_version = "4.1"
  s.source       = { :git => "http://gitlab.caiqr.com/ios_module/TSEncrypt.git", :tag => s.version }
  s.source_files  = "TSEncryptHandler/*.swift"
  #s.exclude_files = "Classes/Exclude"
  s.framework  = "Foundation"


  s.requires_arc = true
  s.dependency "SwiftyRSA"
  s.dependency "CryptoSwift"
end
