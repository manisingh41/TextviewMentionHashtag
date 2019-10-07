//
//  CustomMentionTextView.swift
//  EFSS
//
//  Created by Dhairya on 22/11/18.
//  Copyright © 2018 Durgesh. All rights reserved.
//

//
//  customTextView.swift
//  MentionsHashtagsTextViewDemo
//
//  Created by Dhairya on 21/11/18.
//  Copyright © 2018 Samsung. All rights reserved.
//

import Foundation
import UIKit

enum WordType {
    case hashtag
    case mention
    case Url
    case AttachedPost
}

public class CustomMentionTextView: UITextView {
    
    var textString: NSString?
    var attrString: NSMutableAttributedString?
    var rangeArray = [[String:Any]]()
    var wordsMentionHashtag = [String]()
    var mentionDetection = [Detection]()
    var hashtagDetection = [Detection]()
    var URLDetection = [Detection]()
    var attachementDetection = [Detection]()
    var partArray = [AnyObject]()
    var refsDictionary = [String: Any]()
    var postID = ""
    var isDeleted = false
    var isHashtagAttheRateInserted = false
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(cut(_:)) ||
            action == #selector(copy(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    /// Attributing the upcoming text for the first time from API
    ///
    /// - Parameters:
    ///   - text: array of structure of type PostContentType in which everything is mentioned whether the text is mention, hashtag, url or just text
    ///   - mentionColor: color of mention
    ///   - font: default font
    ///   - hashtagFont: hashtag font
    ///   - mentiontagFont: mention font
    ///   - strArray: not using it, can be ignored as of now.
    ///   - cursorPostion: to keep the cursor to its desired position we use cursorPosition
    public func setTextNew(text: [PostContentType], andMentionColor mentionColor: UIColor, font: UIFont, hashtagFont: UIFont, mentiontagFont: UIFont, strArray: [String], cursorPostion:Int) {
        var normalText = ""
        for i in text{
            normalText += i.value!
        }
        self.attrString = NSMutableAttributedString(string: normalText)
        self.textString = NSString(string: normalText)
        // Set initial font attributes for our string
        attrString?.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange(location: 0, length: (textString?.length)!))
        self.rangeArray = []
        // Call a custom set Hashtag and Mention Attributes Function
        verifyUrlNew(attrName: text, type: TYPE.HREF, color: Fp_s33.color, text: textString! as String, font: Fp_s33.font)
        //verifyUrl(urlString: textString! as String, attrName: "Url", wordPrefix: "", color: Fp_s33.color, font: Fp_s33.font)
        setAttrWithNameNew(attrName: text, type: TYPE.HASHTAG, color: Fp_s32.color, text: textString! as String, font: hashtagFont)
        // setAttrWithName(attrName: "Hashtag", wordPrefix: "#", color: Fp_s32.color, text: textString! as String, font: hashtagFont)
        setAttrWithNameNew(attrName: text, type: TYPE.MENTION, color: mentionColor, text: textString! as String, font: mentiontagFont)
        //setAttrWithName(attrName: "Mention", wordPrefix: "@", color: mentionColor, text: textString! as String, font: mentiontagFont)
//        setAttrWithSharedPost(attrName:text, type: TYPE.POST, color: mentionColor, text: textString! as String, font: mentiontagFont)
        let arbitraryValue: Int = cursorPostion
        if let newPosition = self.position(from: self.beginningOfDocument, offset: arbitraryValue) {
            self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        }
    }
    
    func verifyUrlNew (attrName: [PostContentType], type: TYPE, color: UIColor, text: String, font:UIFont) {
        var finalRange = NSRange(location: 0, length: NSString(string: text).length)
        for word in attrName.filter({$0.type == type}) {
            if String().canOpenURL(string: word.value?.trimmingCharacters(in: .whitespaces)){
                let range = textString?.range(of: word.value!, options: [], range: finalRange)
                attrString?.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range!)
                attrString?.addAttribute(NSAttributedStringKey(rawValue: word.value!), value: 1, range: range!)
                attrString?.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range!)
                attrString?.addAttribute(NSAttributedStringKey.font, value: font, range: range!)
                attrString?.addAttribute(NSAttributedStringKey(rawValue: "URL"), value: word.value!, range: range!)
                self.rangeArray.append(["type":"URL","range":range!])
                finalRange = NSRange(location: (range?.location)! + (range?.length)!, length: NSString(string: text).length - ((range?.location)! + (range?.length)!))
            }
            self.attributedText = attrString
            
        }
    }
    
    //    func canOpenURL(string: String?) -> Bool {
    //        let regExOne = "(^(?:www\\.)|^(?:m\\.))[a-zA-Z0-9@:%._\\+~#=]{2,256}"
    //        let regEx = "^(http(s)?):\\/\\/[a-zA-Z0-9@:%._\\+~#=]{2,256}"
    //        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regExOne])
    //        if predicate.evaluate(with: string!.lowercased()){
    //            return true
    //        }
    //        let predicatehttp = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
    //        if predicatehttp.evaluate(with: string!.lowercased()){
    //            return true
    //        }
    //        return false
    //    }
    
    func setAttrWithNameNew(attrName: [PostContentType], type: TYPE, color: UIColor, text: String, font:UIFont) {
        
        var finalRange = NSRange(location: 0, length: NSString(string: text).length)
        for word in attrName.filter({$0.type == type}) {
            let range = textString?.range(of: word.value!, options: [], range: finalRange)
            //            let range = textString!.range(of: word)
            //self.rangeArray.append(range!)
            attrString?.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range!)
            attrString?.addAttribute(NSAttributedStringKey(rawValue: word.value!), value: 1, range: range!)
            attrString?.addAttribute(NSAttributedStringKey(rawValue: "Clickable"), value: 1, range: range!)
            if type == .MENTION{
                attrString?.addAttribute(NSAttributedStringKey(rawValue: "mention"), value: word.value!, range: range!)
                self.rangeArray.append(["type":"mention","range":range!])
            } else{
                attrString?.addAttribute(NSAttributedStringKey(rawValue: "hashtag"), value: word.value!, range: range!)
                self.rangeArray.append(["type":"hashtag","range":range!])
            }
            attrString?.addAttribute(NSAttributedStringKey(rawValue: "range"), value: range!, range: range!)
            attrString?.addAttribute(NSAttributedStringKey.font, value: font, range: range!)
            finalRange = NSRange(location: (range?.location)! + (range?.length)!, length: NSString(string: text).length - ((range?.location)! + (range?.length)!))
        }
        self.attributedText = attrString
        print(self.rangeArray)
    }
    /// setting the attribute for the mention word
    ///
    /// - Parameters:
    ///   - word: complete textview string in the form of mutable attributed string
    ///   - range: range of string to be attributed
    ///   - color: color of the attributed string
    ///   - text: text to be attributed as bold
    ///   - font: font of the attributed string
    ///   - attrName: text to be attributed string
    ///   - cursorPostion: current cursor position which needs to be put at desired location
    func setAttrWithWordMention(word:NSMutableAttributedString,range:NSRange, color: UIColor, text: String, font:UIFont, attrName:String, cursorPostion:Int) {
        self.attrString = word
        let ranging = NSRange(location: range.location, length: NSString(string: attrName).length)
        //self.rangeArray.append(ranging)
        self.rangeArray.append(["type":"mention","range":ranging])
        attrString?.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: ranging)
        attrString?.addAttribute(NSAttributedStringKey(rawValue: "mention"), value: attrName, range: ranging)
        attrString?.addAttribute(NSAttributedStringKey.font, value: font, range: ranging)
        self.attributedText = attrString
        let arbitraryValue: Int = cursorPostion
        if let newPosition = self.position(from: self.beginningOfDocument, offset: arbitraryValue) {
            self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        }
        print(self.rangeArray)
    }
    
    // Similar to the above function but here we are dealing with Hashtag
    func setAttrWithWordHashtag(word:NSMutableAttributedString,range:NSRange, color: UIColor, text: String, font:UIFont, attrName:String, cursorPostion:Int) {
        self.attrString = word
        self.textString = NSString(string: word.string)
        let ranging = NSRange(location: range.location, length: NSString(string: attrName).length)
        //self.rangeArray.append(ranging)
        //        for i in 0...self.rangeArray.count-1 where (range.location+1) == (self.rangeArray[i]["range"] as? NSRange)!.location{
        //            self.rangeArray.remove(at: i)
        //        }
        self.rangeArray.append(["type":"hashtag","range":ranging])
        attrString?.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: ranging)
        attrString?.addAttribute(NSAttributedStringKey(rawValue: "hashtag"), value: attrName, range: ranging)
        attrString?.addAttribute(NSAttributedStringKey.font, value: font, range: ranging)
        self.attributedText = attrString
        let arbitraryValue: Int = cursorPostion
        if let newPosition = self.position(from: self.beginningOfDocument, offset: arbitraryValue) {
            self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        }
        print(self.rangeArray)
    }
    
    // Similar to the above function but here we are dealing with URL
    func setAttrWithWordURL(word:NSMutableAttributedString,range:NSRange, color: UIColor, text: String, font:UIFont, attrName:String, cursorPostion:Int) {
        self.attrString = word
        self.textString = NSString(string: word.string)
        let ranging = NSRange(location: range.location, length: NSString(string: attrName).length)
        //self.rangeArray.append(ranging)
        self.rangeArray.append(["type":"URL","range":ranging])
        attrString?.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: ranging)
        attrString?.addAttribute(NSAttributedStringKey(rawValue: "URL"), value: attrName, range: ranging)
        attrString?.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: ranging)
        attrString?.addAttribute(NSAttributedStringKey.font, value: font, range: ranging)
        self.attributedText = attrString
        let arbitraryValue: Int = cursorPostion
        if let newPosition = self.position(from: self.beginningOfDocument, offset: arbitraryValue) {
            self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        }
        print(self.rangeArray)
    }
    func hashtagRecursion(finalRangee:NSRange,texttemp:String)  {
        var finalRange = finalRangee
        for i in self.hashtagDetection{
            let wordtemp = i.style.typedAttributes.values.first![NSAttributedStringKey(rawValue: "hashtag")]
            let str = wordtemp as? String ?? " "
            if textString?.range(of: str, options: [], range: finalRange).location == NSNotFound{
                
            } else{
                let range = textString?.range(of: str, options: [], range: finalRange)
                //            let range = textString!.range(of: word)
                if range?.location != 0 && (textString?.substring(to: (range?.location)!).last != " " || textString?.substring(to: (range?.location)!).last != "\n"){
                    if textString?.substring(to: (range?.location)!).last == "\n"{
                        
                    } else if textString?.substring(to: (range?.location)!).last == " "{
                        
                    } else{
                        finalRange = NSRange(location: (range?.location)! + (range?.length)!, length: NSString(string: texttemp).length - ((range?.location)! + (range?.length)!))
                        hashtagRecursion(finalRangee: finalRange, texttemp: texttemp)
                        return
                    }
                }
                //self.rangeArray.append(range!)
                self.rangeArray.append(["type":"hashtag","range":range!])
                attrString?.addAttribute(NSAttributedStringKey.foregroundColor, value: Fp_s32.color, range: range!)
                attrString?.addAttribute(NSAttributedStringKey.font, value: Fp_s32.font, range: range!)
                attrString?.addAttribute(NSAttributedStringKey(rawValue: "hashtag"), value: str, range: range!)
                finalRange = NSRange(location: (range?.location)! + (range?.length)!, length: NSString(string: texttemp).length - ((range?.location)! + (range?.length)!))
            }
        }
    }
    
    func convertingToNsRange(txt:String,range:NSRange) -> NSRange {
        // Compute String.UnicodeScalarView indices for first and last position:
        let fromIdx = txt.unicodeScalars.index(txt.unicodeScalars.startIndex, offsetBy: range.location)
        let toIdx = txt.unicodeScalars.index(fromIdx, offsetBy: range.length)
        // Compute corresponding NSRange:
        let nsRange = NSRange(fromIdx..<toIdx, in: txt)
        return nsRange
    }
    
    /// this is used after every input to layout the complete textview string as attributed string and keep the range Array updated
    ///
    /// - Parameters:
    ///   - word: complete textview string in the form of mutable attributed string
    ///   - text: textview text in string form
    ///   - font: default font
    ///   - cursorPostion: current cursor position to be passed
    func setAttrWithoutSpace(word:NSMutableAttributedString, text: String, font:UIFont, cursorPostion:Int) {
        self.attrString = word
        self.textString = NSString(string: text)
        var finalRange = NSRange(location: 0, length: self.textString!.length)
        attrString?.addAttribute(NSAttributedStringKey.font, value: font, range: NSRange(location: 0, length: (textString?.length)!))
        self.rangeArray = []
        for i in self.mentionDetection{
            let wordtemp = i.style.typedAttributes.values.first![NSAttributedStringKey(rawValue: "mention")]
            let str = wordtemp as? String ?? " "
            print(wordtemp as? String ?? " ")
            if textString?.range(of: str, options: [], range: finalRange).location == NSNotFound{
                
            } else{
                //let rangeing = textString?.range(of: str, options: [], range: finalRange)
                let range = textString?.range(of: str, options: [], range: finalRange)
                //            let range = textString!.range(of: word)
                //self.rangeArray.append(range!)
                self.rangeArray.append(["type":"mention","range":range!])
                attrString?.addAttribute(NSAttributedStringKey.foregroundColor, value: Fp_s29.color, range: range!)
                attrString?.addAttribute(NSAttributedStringKey.font, value: Fp_s29.font, range: range!)
                attrString?.addAttribute(NSAttributedStringKey(rawValue: "mention"), value: str, range: range!)
                finalRange = NSRange(location: (range!.location) + (range!.length), length: NSString(string: text).length - ((range!.location) + (range!.length)))
            }
        }
        finalRange = NSRange(location: 0, length: self.textString!.length)
        self.hashtagRecursion(finalRangee: finalRange, texttemp: text)
        finalRange = NSRange(location: 0, length: self.textString!.length)
        for i in self.URLDetection{
            let wordtemp = i.style.typedAttributes.values.first![NSAttributedStringKey(rawValue: "URL")]
            let str = wordtemp as? String ?? " "
            if textString?.range(of: str, options: [], range: finalRange).location == NSNotFound{
                
            } else{
                let range = textString?.range(of: str, options: [], range: finalRange)
                //            let range = textString!.range(of: word)
                //self.rangeArray.append(range!)
                self.rangeArray.append(["type":"URL","range":range!])
                attrString?.addAttribute(NSAttributedStringKey.foregroundColor, value: Fp_s33.color, range: range!)
                attrString?.addAttribute(NSAttributedStringKey.font, value: Fp_s33.font, range: range!)
                attrString?.addAttribute(NSAttributedStringKey(rawValue: "URL"), value: str, range: range!)
                attrString?.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: range!)
                finalRange = NSRange(location: (range?.location)! + (range?.length)!, length: NSString(string: text).length - ((range?.location)! + (range?.length)!))
            }
        }
        //testing for deleting hashtag
        if isDeleted{
            partArray = []
            let attributedStringtemp = word.attributedString
            let range = NSMakeRange(0, (attributedStringtemp.length))
            attributedStringtemp.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (object, range, stop) in
                if object.keys.contains(NSAttributedStringKey.attachment) {
                    if let attachment = object[NSAttributedStringKey.attachment] as? NSTextAttachment {
                        if let image = attachment.image {
                            partArray.append(image)
                        } else if let image = attachment.image(forBounds: attachment.bounds, textContainer: nil, characterIndex: range.location) {
                            partArray.append(image)
                        }
                    }
                } else {
                    let stringValue : String = attributedStringtemp.attributedSubstring(from: range).string
                    partArray.append(stringValue as AnyObject)
                    //                if (!stringValue.trimmingCharacters(in: .whitespaces).isEmpty) {
                    //                    parts.append(stringValue as AnyObject)
                    //                }
                }
            }
            //end of testing
            isDeleted = false
        }
        if isHashtagAttheRateInserted{
            partArray = []
            let attributedStringtemp = text.attributedString
            let range = NSMakeRange(0, (attributedStringtemp.length))
            attributedStringtemp.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (object, range, stop) in
                if object.keys.contains(NSAttributedStringKey.attachment) {
                    if let attachment = object[NSAttributedStringKey.attachment] as? NSTextAttachment {
                        if let image = attachment.image {
                            partArray.append(image)
                        } else if let image = attachment.image(forBounds: attachment.bounds, textContainer: nil, characterIndex: range.location) {
                            partArray.append(image)
                        }
                    }
                } else {
                    let stringValue : String = attributedStringtemp.attributedSubstring(from: range).string
                    partArray.append(stringValue as AnyObject)
                    //                if (!stringValue.trimmingCharacters(in: .whitespaces).isEmpty) {
                    //                    parts.append(stringValue as AnyObject)
                    //                }
                }
            }
            //end of testing
            isHashtagAttheRateInserted = false
        }
        self.attributedText = attrString
        let arbitraryValue: Int = cursorPostion
        if let newPosition = self.position(from: self.beginningOfDocument, offset: arbitraryValue) {
            self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        }
    }
    
}
