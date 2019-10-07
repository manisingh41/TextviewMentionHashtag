#
#  Be sure to run `pod spec lint CustomMention.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name         = "CustomMention"
  s.version      = "1.0.0"
  s.summary      = "A custom textview for showing hashtag, mention url or attachments."

  s.description  = "A custom textview for showing hashtag, mention url or attachments. When you start with # and give space after writing a word it turns out to be hashtag, similar for the mention when used with @. URL can be used too."
  s.homepage     = "http://EXAMPLE/CustomMention"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  s.license      = "MIT"


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author             = { "NAGMANISINGH" => "nagmanisingh41@gmail.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
 
    s.platform     = :ios, "10.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
 

     s.source       = { :git => "https://github.com/manisingh41/TextviewMentionHashtag", :tag => "1.0.0" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
 

  s.source_files  = "CustomMention"
  s.exclude_files = "Classes/Exclude"
  s.swift_version = "4.2" 
end