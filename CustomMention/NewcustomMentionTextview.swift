//
//  customMentionTextview.swift
//  EFSS
//
//  Created by Durgesh on 28/02/19.
//  Copyright © 2019 Durgesh. All rights reserved.
//

import UIKit
public protocol NewcustomMentionTextviewDelegate: class {
    func attheRatePressed(str:String)
    func hideTableview()
    func hideNoSearchView()
    func enableRightButton()
    func disableRightButton()
    func cancelPreviousAPICall()
    func dynamicHeightTextview(value:CGFloat)
    func showScrollIndicator()
    func showWarningForMentionTxtView(toShow:Bool)
    func showSharedPostDeleteConfirmation()
}
extension NewcustomMentionTextviewDelegate{
    func showWarningForMentionTxtView(toShow:Bool) {
    }
    func showSharedPostDeleteConfirmation() {
    }
}
public struct PostContentType {
    var value: String?
    var id: String?
    var type: TYPE?
}
enum TYPE {
    case MENTION
    case HREF
    case TEXT
    case HASHTAG
    case POST
}

public class NewcustomMentionTextview: UIView, UITextViewDelegate {
    
    public var textviewEditMode: CustomMentionTextView?
    var placeholderShow = true
    var searchString = ""
    var insertionIndex:Int = -1
    var hashtagInsertionTag = -1
    var hashtagRange: NSRange?
    var indexList:[Int] = []
    var contentList:[String] = []
    var resultList:[PostContentType] = []
    var tempArrayDemo:[String] = []
    weak var delegate: NewcustomMentionTextviewDelegate?
    var timerForShowScrollIndicator: Timer?
    var widthOfBlank : CGFloat = 0.0
    var refsValue = [String: Any]()
    var selectedPostId = ""
    var showDeleteAttachment = true
    var isAtTheRatePressed = false
    let textCount = 10000
    override init(frame: CGRect) {
        super.init(frame: frame)
        //createCustomTextview()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //createCustomTextview()
    }
    public func createCustomTextview(wid:CGFloat) {
        textviewEditMode = CustomMentionTextView(frame: CGRect(x: 0.0, y: 0.0, width: wid, height: self.frame.height))
        textviewEditMode?.isScrollEnabled = false
        textviewEditMode?.isEditable = true
        textviewEditMode?.setPlaceholderNew(localizeValue: "@Mention anyone or any business group that needs to see this post.\nYou can easily search for related posts if you add #hashtags.")
        textviewEditMode?.textColor = fp_s59.color
        textviewEditMode?.font = fp_s59.font
        textviewEditMode?.delegate = self
        //textviewEditMode?.autocorrectionType = .no
        textviewEditMode?.backgroundColor = fp_s16.color
        self.addSubview(textviewEditMode!)
    }
    
    public class func instanceFromNib() -> NewcustomMentionTextview {
        return (UINib(nibName: "NewcustomMentionTextview", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? NewcustomMentionTextview)!
    }
    
    func setTextTempNew(str:[PostContentType]) {
        textviewEditMode?.refsDictionary = refsValue
        textviewEditMode?.postID = selectedPostId
        textviewEditMode?.setTextNew(text: str, andMentionColor: Fp_s29.color, font: fp_s26.font, hashtagFont: Fp_s32.font, mentiontagFont: Fp_s29.font, strArray: self.tempArrayDemo, cursorPostion: self.getCurrentCursorPostion())
            self.setCurrentCursorPositionToEnd()
    }
    
    func configureContentsLabelNew(content:String) -> [PostContentType]{
        var currEndIndex = 0
        self.indexList.append(0)
        do {
            let input = content
            let regex = try NSRegularExpression(pattern: "[(<@)|(<!)|(<#)|(<$)]{1}[^<^>]*>", options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
            if matches.count>0{
                for i in 0...matches.count-1{
                    if matches[i].range.location != currEndIndex{
                        self.indexList.append(matches[i].range.location)
                    }
                    currEndIndex = matches[i].range.length+matches[i].range.location
                    self.indexList.append(currEndIndex)
                }
            }
            self.indexList.append(NSString(string: content).length)
        } catch {
            // regex was bad!
        }
        print(self.indexList)
        
        if self.indexList.count>0{
            for i in 0..<self.indexList.count-1{
                let startPos = self.indexList[i]
                let endPos = self.indexList[i+1]
                if startPos != endPos{
                    self.contentList.append(NSString(string: content).substring(with: NSRange(location: startPos, length: endPos-startPos)))
                    //self.contentList.append(content.substring(from: startPos, to: endPos))
                }
            }
        }
        print(self.contentList)
        
        if self.contentList.count>0{
            for i in 0...self.contentList.count-1{
                if self.contentList[i].range(of: "(<@).*(>)", options: .regularExpression, range: nil, locale: nil) != nil && self.contentList[i].contains("|"){
                    if self.contentList[i].hasSuffix("|>"){
                        let obj = PostContentType(value: self.contentList[i], id:  nil, type: TYPE.TEXT)
                        self.resultList.append(obj)
                        continue
                    }
                    let tempArray = self.contentList[i].split(separator: "|")
                    let name = tempArray[0].replacingOccurrences(of: "<@", with: "")
                    let id = tempArray[1].replacingOccurrences(of: ">", with: "")
                    if !refsValue.keys.contains(id){
                        let obj = PostContentType(value: self.contentList[i], id:  nil, type: TYPE.TEXT)
                        self.resultList.append(obj)
                        continue
                    }
                    let obj = PostContentType(value: name, id: id, type: TYPE.MENTION)
                    self.resultList.append(obj)
                } else if self.contentList[i].range(of: "(<$)*(>)", options: .regularExpression, range: nil, locale: nil) != nil && self.contentList[i].contains("|"){
                    if self.contentList[i].hasSuffix("|>"){
                        let obj = PostContentType(value: self.contentList[i], id:  nil, type: TYPE.TEXT)
                        self.resultList.append(obj)
                        continue
                    }
                    let tempArray = self.contentList[i].split(separator: "|")
                    //let name = tempArray[0].replacingOccurrences(of: "<$", with: "")
                    let id = tempArray[1].replacingOccurrences(of: ">", with: "")
                    selectedPostId = id
                    if !refsValue.keys.contains(id){
                        let obj = PostContentType(value: self.contentList[i], id:  nil, type: TYPE.TEXT)
                        self.resultList.append(obj)
                        continue
                    }
                    let obj = PostContentType(value: "\u{FEFF}", id: id, type: TYPE.POST)
                    self.resultList.append(obj)
                } else if self.contentList[i].range(of: "(<!).*(>)", options: .regularExpression, range: nil, locale: nil) != nil{
                    let stringURL = self.contentList[i].substring(from: 2, to: self.contentList[i].count-1)
                    let obj = PostContentType(value: stringURL, id:  nil, type: TYPE.HREF)
                    self.resultList.append(obj)
                } else if self.contentList[i].range(of: "(<#).*(>)", options: .regularExpression, range: nil, locale: nil) != nil && !self.contentList[i].contains(" ") && self.contentList[i].last == ">"{
                    let stringHashtag = self.contentList[i].substring(from: 1, to: self.contentList[i].count-1)
                    let obj = PostContentType(value: stringHashtag, id:  nil, type: TYPE.HASHTAG)
                    self.resultList.append(obj)
                } else{
                    let obj = PostContentType(value: self.contentList[i], id:  nil, type: TYPE.TEXT)
                    self.resultList.append(obj)
                }
            }
        }
        return self.resultList
    }
    
    //detecting attributed ranges of strings in complete textview's text, so that it can be used for painting the uitextview depending on the nature of the text. text can be mention, hashtag or url
    func checking() {
        //taking mention out of attributed string
        let attArray = self.textviewEditMode?.attributedText.styleMentions(.backgroundColor(Fp_s29.color))
        let detections = attArray?.detections
        let mentionsArray = detections?.filter({($0.style.typedAttributes.values.first?.keys.contains(NSAttributedStringKey(rawValue: "mention")))!})
        print(mentionsArray!)
        
        //taking hashtags out of attributed string
        let attHashtagArray = self.textviewEditMode?.attributedText.styleMentions(.backgroundColor(Fp_s32.color))
        let detectionsHashtags = attHashtagArray?.detections
        let hashtagArray = detectionsHashtags?.filter({($0.style.typedAttributes.values.first?.keys.contains(NSAttributedStringKey(rawValue: "hashtag")))!})
        print(hashtagArray!)
        //testing the attachment detection.
        let attachemntarray = detectionsHashtags?.filter({($0.style.typedAttributes.values.first?.keys.contains(NSAttributedStringKey(rawValue: "attachment")))!})
        print(attachemntarray!)
        //taking URL out of attributed string
        let attURLArray = self.textviewEditMode?.attributedText.styleMentions(.backgroundColor(Fp_s33.color))
        let detectionsURL = attURLArray?.detections
        let URLArray = detectionsURL?.filter({($0.style.typedAttributes.values.first?.keys.contains(NSAttributedStringKey(rawValue: "URL")))!})
        print(URLArray!)
        
        //taking attachement out of attributed string
        var parts = [AnyObject]()
        let attributedString = self.textviewEditMode?.attributedText
        let range = NSMakeRange(0, (attributedString?.length)!)
        attributedString?.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (object, range, stop) in
            if object.keys.contains(NSAttributedStringKey.attachment) {
                if let attachment = object[NSAttributedStringKey.attachment] as? NSTextAttachment {
                    if let image = attachment.image {
                        parts.append(image)
                    } else if let image = attachment.image(forBounds: attachment.bounds, textContainer: nil, characterIndex: range.location) {
                        parts.append(image)
                    }
                }
            } else {
                let stringValue : String = attributedString!.attributedSubstring(from: range).string
                parts.append(stringValue as AnyObject)
//                if (!stringValue.trimmingCharacters(in: .whitespaces).isEmpty) {
//                    parts.append(stringValue as AnyObject)
//                }
            }
        }
        print(parts)
        //////========================
        self.textviewEditMode?.mentionDetection = mentionsArray!
        self.textviewEditMode?.hashtagDetection = hashtagArray!
        self.textviewEditMode?.URLDetection = URLArray!
        self.textviewEditMode?.attachementDetection = attachemntarray!
        self.textviewEditMode?.partArray = parts
    }
    
    func checkingforAttachment() {
        //taking attachement out of attributed string
        var parts = [AnyObject]()
        if let attributedString = self.textviewEditMode?.attrString{
            let range = NSMakeRange(0, (attributedString.length))
            attributedString.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions(rawValue: 0)) { (object, range, stop) in
                if object.keys.contains(NSAttributedStringKey.attachment) {
                    if let attachment = object[NSAttributedStringKey.attachment] as? NSTextAttachment {
                        if let image = attachment.image {
                            parts.append(image)
                        } else if let image = attachment.image(forBounds: attachment.bounds, textContainer: nil, characterIndex: range.location) {
                            parts.append(image)
                        }
                    }
                } else {
                    let stringValue : String = attributedString.attributedSubstring(from: range).string
                    parts.append(stringValue as AnyObject)
                    //                if (!stringValue.trimmingCharacters(in: .whitespaces).isEmpty) {
                    //                    parts.append(stringValue as AnyObject)
                    //                }
                }
            }
            print(parts)
            self.textviewEditMode?.partArray = parts
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
    
   public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == fp_s59.color && placeholderShow {
            placeholderShow = false
            textView.text = nil
            textView.textColor = UIColor.black
        }
        if textView.text.isEmpty {
            textView.text = ""
            //textView.checkPlaceholder()
            self.checkingPlaceholderAndSaveButton(txtView: textView)
        }
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ""
            //textView.checkPlaceholder()
            self.checkingPlaceholderAndSaveButton(txtView: textView)
            textView.font = fc6.font
            textView.textColor = UIColor.black
        }
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            delegate?.showWarningForMentionTxtView(toShow: true)
        }
    }
    @objc func showScrollIndicatorsInContacts() {
        UIView.animate(withDuration: 0.001) {
            //self.textviewEditMode?.flashScrollIndicators()
            self.delegate?.showScrollIndicator()
        }
    }
    
    func startTimerForShowScrollIndicator() {
        self.timerForShowScrollIndicator = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.showScrollIndicatorsInContacts), userInfo: nil, repeats: false)
    }
    public func adjustFramesTextView() {
//        var frameTextview = textviewEditMode?.frame
//        frameTextview?.size.height = (textviewEditMode?.contentSize.height)! > 134.0 ? (textviewEditMode?.contentSize.height)! : 134.0
//        delegate?.dynamicHeightTextview(value: (textviewEditMode?.contentSize.height)! > 134.0 ? (textviewEditMode?.contentSize.height)! : 134.0)
//        textviewEditMode?.frame = frameTextview!
        
        let fixedWidth = textviewEditMode?.frame.size.width
        let newSize = textviewEditMode?.sizeThatFits(CGSize(width: fixedWidth!, height: CGFloat.greatestFiniteMagnitude))
        delegate?.dynamicHeightTextview(value: (newSize?.height)! > 134.0 ? ((newSize?.height)!+20) : 134.0)
        textviewEditMode?.frame.size = CGSize(width: max((newSize?.width)!, fixedWidth!), height: (newSize?.height)! > 134.0 ? ((newSize?.height)!+20) : 134.0)
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //textView.checkPlaceholder()
        self.checkingPlaceholderAndSaveButton(txtView: textView)
        if self.searchString.isEmpty{
            delegate?.hideNoSearchView()
        }
        if textView.text.count + (text.count - range.length) >= textCount{
            UIApplication.shared.windows.last?.makeToast(NSLocalizedString("post_write_alert_01", comment: ""))
//            kAppDelegate.window?.makeToast(NSLocalizedString("post_write_alert_01", comment: ""))
            return false
        }
        let currentText = textView.text as NSString
        if text == "\n" {
            widthOfBlank += textView.frame.size.width
        }

        let widthOfString =  widthOfBlank + textView.text.widthOfString(usingFont:fp2.font)
        if widthOfString > (textView.frame.size.width-5) * 2 {
            startTimerForShowScrollIndicator()
        }
        if (text.count<=0 && range.length > 0 && range.length != 1){
            delegate?.hideTableview()
            delegate?.hideNoSearchView()
            return true
        }
        let updatedText = currentText.replacingCharacters(in: range, with: text) as NSString
        if updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            delegate?.disableRightButton()
            self.insertionIndex = -1
            self.hashtagInsertionTag = -1
            searchString = ""
            delegate?.hideTableview()
            delegate?.hideNoSearchView()
            //return true
        } else{
            delegate?.enableRightButton()
        }
        self.checking()
//        let mutableStr = NSMutableAttributedString(string: String(currentText))
//        textviewEditMode?.setAttrWithoutSpace(word: mutableStr, text: String(currentText), font: Fp_s26.font, cursorPostion: getCurrentCursorPostion())
        //handling backspace for mention hashtag and url
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        // handling backspace
        if isBackSpace == -92{
            delegate?.hideTableview()
            delegate?.hideNoSearchView()
            let rangeArr = self.textviewEditMode?.rangeArray
            if (rangeArr?.count)!>0{
                for i in 0...(rangeArr?.count)!-1 where (rangeArr![i]["range"] as? NSRange)!.length+(rangeArr![i]["range"] as? NSRange)!.location == range.location+range.length && rangeArr![i]["type"]! as? String != "post"{
                    let totalAttrStr = self.textviewEditMode?.attributedText
                    let totalMuatble:NSMutableAttributedString = NSMutableAttributedString.init(attributedString: totalAttrStr!)
                    totalMuatble.deleteCharacters(in: (rangeArr![i]["range"] as? NSRange)!)
                    if totalMuatble.string.isEmpty || totalMuatble.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                        delegate?.disableRightButton()
                        self.insertionIndex = -1
                        self.hashtagInsertionTag = -1
                        searchString = ""
                    }
                    self.insertionIndex = -1
                    self.hashtagInsertionTag = -1
                    searchString = ""
                    self.setCurrentCursorPosition(cursorPostion: (rangeArr![i]["range"] as? NSRange)!.location)
                    self.checking()
                    textviewEditMode?.isDeleted = true
                    textviewEditMode?.setAttrWithoutSpace(word: totalMuatble, text: totalMuatble.string, font: Fp_s26.font, cursorPostion: getCurrentCursorPostion())
                    //textView.checkPlaceholder()
                    self.checkingPlaceholderAndSaveButton(txtView: textView)
                    return false
                }
                for i in 0...(rangeArr?.count)!-1 where getCurrentCursorPostion() == (rangeArr![i]["range"] as? NSRange)!.location+1{
                    if showDeleteAttachment && rangeArr![i]["type"]! as? String == "post"{
                        self.delegate?.showSharedPostDeleteConfirmation()
                    }
                    showDeleteAttachment = true
                    return false
                }
            }
            if getCurrentCursorPostion() == self.insertionIndex+1{
                self.insertionIndex = -1
                searchString = ""
            }
            if self.insertionIndex != -1{
                if searchString.count>0{
                    searchString = String(searchString.dropLast())
                }
                if getCurrentCursorPostion() == 0{
                    
                } else{
                    if String(updatedText).substring(to: getCurrentCursorPostion()).last! == " " || updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || String(updatedText).substring(to: getCurrentCursorPostion()).last! == "\n"{
                        self.insertionIndex = -1
                        searchString = ""
                    }
                }
            }
            if self.hashtagInsertionTag != -1{
                if searchString.count>0{
                    searchString = String(searchString.dropLast())
                }
                if getCurrentCursorPostion() == 0{
                    
                } else{
                    if String(updatedText).substring(to: getCurrentCursorPostion()).last! == " "{
                        self.hashtagInsertionTag = -1
                        searchString = ""
                    }
                }
            }
            if self.hashtagInsertionTag != 1 && self.insertionIndex == -1 && searchString.count>0{
                searchString = String(searchString.dropLast())
            }
            if getCurrentCursorPostion() == 0{
                
            } else{
                let stringArr = updatedText.substring(to: getCurrentCursorPostion()-1)
                let strnew = stringArr.components(separatedBy: " ").last
                let newTemp = strnew?.components(separatedBy: "\n")
                self.searchString = (newTemp?.last)!
                if self.searchString.first == "#"{
                    self.hashtagInsertionTag = 1
                    self.hashtagRange = NSRange(location: getCurrentCursorPostion()-2-self.searchString.count, length: 0)
                }
            }
        }
        if text == " " || text == "\n" {
            if self.hashtagInsertionTag == 1{
                let stringArr = textView.text.substring(to: getCurrentCursorPostion())
                let strnew = stringArr.components(separatedBy: " ").last
                let newTemp = strnew?.components(separatedBy: "\n")
                self.searchString = (newTemp?.last)!
                if self.searchString.count>1 && String().checkForHashtag(str: self.searchString){
                    if self.searchString.first == "#"{
                        self.hashtagInsertionTag = 1
                        self.hashtagRange = NSRange(location: getCurrentCursorPostion()-NSString(string: self.searchString).length, length: 0)
                    }
                    let totalAttrStr = self.textviewEditMode?.attributedText
                    let totalMuatble:NSMutableAttributedString = NSMutableAttributedString.init(attributedString: totalAttrStr!)
                    if self.hashtagRange != nil{
                        textviewEditMode?.setAttrWithWordHashtag(word: totalMuatble, range: self.hashtagRange!, color: Fp_s32.color, text: totalMuatble.string, font: Fp_s32.font, attrName: searchString, cursorPostion: getCurrentCursorPostion())
                    }
                }
            }
            if self.insertionIndex == -1 && self.hashtagInsertionTag == -1{
                let stringArr = NSString(string: textView.text).substring(to: getCurrentCursorPostion())
                //let stringArr = textView.text.substring(to: getCurrentCursorPostion())
                let strnew = stringArr.components(separatedBy: " ").last
                let newTemp = strnew?.components(separatedBy: "\n")
                self.searchString = (newTemp?.last)!
                if String().canOpenURL(string: self.searchString){
                    let rangeURL = NSRange(location: getCurrentCursorPostion()-searchString.count, length: 0)
                    let totalAttrStr = self.textviewEditMode?.attributedText
                    let totalMuatble:NSMutableAttributedString = NSMutableAttributedString.init(attributedString: totalAttrStr!)
                    textviewEditMode?.setAttrWithWordURL(word: totalMuatble, range: rangeURL, color: Fp_s33.color, text: searchString, font: Fp_s33.font, attrName: searchString, cursorPostion: getCurrentCursorPostion())
                }
            }
            self.insertionIndex = -1
            searchString = ""
            self.hashtagInsertionTag = -1
            delegate?.hideTableview()
            delegate?.hideNoSearchView()
        }
        if text == "#"{
            let curCursor = getCurrentCursorPostion()
            if curCursor == 0{
                isAtTheRatePressed = true
                self.hashtagInsertionTag = 1
                searchString = ""
                self.hashtagRange = NSRange(location: getCurrentCursorPostion(), length: searchString.count)
            } else if ((currentText as String).substring(to: curCursor)).last! == " " || ((currentText as String).substring(to: curCursor)).last! == "\n"{
                print("catched it")
                isAtTheRatePressed = true
                self.hashtagInsertionTag = 1
                searchString = ""
                self.hashtagRange = NSRange(location: getCurrentCursorPostion(), length: searchString.count)
            }
        }
        if self.hashtagInsertionTag == 1{
            //self.searchString += text
        }
        if text == "@"{
            let curCursor = getCurrentCursorPostion()
            if curCursor == 0{
                isAtTheRatePressed = true
                searchString = "@"
                self.insertionIndex = getCurrentCursorPostion()
            } else if text == "@" && (updatedText.substring(to: getCurrentCursorPostion()).last! == " " || updatedText.substring(to: getCurrentCursorPostion()).last! == "\n" || String(updatedText.substring(to: getCurrentCursorPostion()).last!) == ""){
                isAtTheRatePressed = true
                searchString = "@"
                self.insertionIndex = getCurrentCursorPostion()
            } else if text == "@" && getCurrentCursorPostion() >= 2{
                if (textviewEditMode?.attrString?.containsAttachments(in: NSRange(location: getCurrentCursorPostion()-2, length: 1)))!{
                    isAtTheRatePressed = true
                    searchString = "@"
                    self.insertionIndex = getCurrentCursorPostion()
                }
            }
        }
        if text != " " && text != "\n" && self.hashtagInsertionTag != 1 && self.insertionIndex == -1{
            self.searchString += text
        }
        if text != " " && text != "\n" && self.insertionIndex != -1{
            searchString += text
            if searchString.first == "@" && searchString.count>1{
                searchString = String(searchString.dropFirst())
            }
            delegate?.attheRatePressed(str: searchString)
        } else{
            delegate?.cancelPreviousAPICall()
            delegate?.hideTableview()
            delegate?.hideNoSearchView()
        }
        self.adjustFramesTextView()
        return true
    }
    func returnedStringAPI(returnedString:String)  {
        showDeleteAttachment = false
        if self.insertionIndex == -1{
            delegate?.hideTableview()
        } else{
            let finalRange = NSRange(location: self.insertionIndex, length: NSString(string: (self.textviewEditMode?.text)!).length-self.insertionIndex)
            var str = ""
            if self.getCurrentCursorPostion() < self.insertionIndex{
                
            } else{
                str = (self.textviewEditMode?.textString?.substring(with: NSRange(location: self.insertionIndex, length: self.getCurrentCursorPostion()-self.insertionIndex)))!
            }
            let rangeNew:NSRange?
            if str == "@"{
                //rangeNew = self.convertingToNsRange(txt: String(self.searchString), range: finalRange)
                //rangeNew = updatedText.range(of: self.searchString, options: [], range: finalRange)
                rangeNew = NSString(string: (self.textviewEditMode?.text)!).range(of: str, options: [], range: finalRange)
            } else{
                //rangeNew = self.convertingToNsRange(txt: String(self.searchString), range: finalRange)
                rangeNew = NSString(string: (self.textviewEditMode?.text)!).range(of: str, options: [], range: finalRange)
            }
            if rangeNew?.location == NSNotFound{
                delegate?.hideTableview()
                self.searchString = ""
            } else{
                //self.setTextTemp(str: totalMuatble)
                let totalAttrStr = self.textviewEditMode?.attributedText
                let totalMuatble:NSMutableAttributedString = NSMutableAttributedString.init(attributedString: totalAttrStr!)
                totalMuatble.replaceCharacters(in: rangeNew!, with: returnedString+" ")
                self.textviewEditMode?.setAttrWithWordMention(word: totalMuatble, range: rangeNew!, color: Fp_s29.color, text: returnedString, font: Fp_s29.font, attrName: returnedString, cursorPostion: self.getCurrentCursorPostion())
                delegate?.hideTableview()
                self.setCurrentCursorPosition(cursorPostion: self.insertionIndex+returnedString.count+1)
                self.searchString = ""
                // self.insertionIndex = -1
                self.checking()
                self.textviewEditMode?.setAttrWithoutSpace(word: totalMuatble, text: totalMuatble.string, font: Fp_s26.font, cursorPostion: self.insertionIndex+returnedString.count+1)
                self.insertionIndex = -1
            }
        }
        self.adjustFramesTextView()
    }
    public func textViewDidChange(_ textView: UITextView) {
        //textView.checkPlaceholder()
        self.checkingPlaceholderAndSaveButton(txtView: textView)
        self.checking()
        let mutableStr = NSMutableAttributedString(string: String(textView.text))
        textviewEditMode?.setAttrWithoutSpace(word: mutableStr, text: String(textView.text), font: Fp_s26.font, cursorPostion: getCurrentCursorPostion())
        print(getCurrentCursorPostion())
        print("current position cursor")
        self.adjustFramesTextView()
    }
    
    func checkingPlaceholderAndSaveButton(txtView: UITextView) {
        if txtView.checkPlaceholderNew(){
            //it means text is empty in the textview
            delegate?.disableRightButton()
        } else{
            if txtView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                delegate?.disableRightButton()
            } else{
                delegate?.enableRightButton()
            }
        }
        delegate?.showWarningForMentionTxtView(toShow: false)
    }
    
    func deleteSharedPost() {
        let rangeArr = self.textviewEditMode?.rangeArray
        if (rangeArr?.count)!>0{
            for i in 0...(rangeArr?.count)!-1 where (rangeArr![i]["range"] as? NSRange)!.length+(rangeArr![i]["range"] as? NSRange)!.location == getCurrentCursorPostion(){
                let totalAttrStr = self.textviewEditMode?.attributedText
                let totalMuatble:NSMutableAttributedString = NSMutableAttributedString.init(attributedString: totalAttrStr!)
                //totalMuatble.replaceCharacters(in: NSRange(location: (rangeArr![i]["range"] as? NSRange)!.location, length: 1), with: "")
                totalMuatble.deleteCharacters(in: NSRange(location: (rangeArr![i]["range"] as? NSRange)!.location, length: 1))
                if totalMuatble.string.isEmpty || totalMuatble.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                    delegate?.disableRightButton()
                    self.insertionIndex = -1
                    self.hashtagInsertionTag = -1
                    searchString = ""
                }
                self.insertionIndex = -1
                self.hashtagInsertionTag = -1
                searchString = ""
                self.setCurrentCursorPosition(cursorPostion: (rangeArr![i]["range"] as? NSRange)!.location)
                self.checking()
                textviewEditMode?.partArray = []
                textviewEditMode?.setAttrWithoutSpace(word: totalMuatble, text: totalMuatble.string, font: Fp_s26.font, cursorPostion: getCurrentCursorPostion())
                //textView.checkPlaceholder()
                self.checkingPlaceholderAndSaveButton(txtView: textviewEditMode!)
            }
        }
    }
    
    func setcursorToPreviouspostion() {
        self.setCurrentCursorPosition(cursorPostion: getCurrentCursorPostion()+1)
    }
    public func textViewDidChangeSelection(_ textView: UITextView) {
        let currentCursor = getCurrentCursorPostion()
        let rangeArr = self.textviewEditMode?.rangeArray
        if (rangeArr?.count)!>0{
            for i in 0...(rangeArr?.count)!-1 where currentCursor>(rangeArr![i]["range"] as? NSRange)!.location && currentCursor<((rangeArr![i]["range"] as? NSRange)!.location+(rangeArr![i]["range"] as? NSRange)!.length){
                if currentCursor == (rangeArr![i]["range"] as? NSRange)!.location+1{
                    self.setCurrentCursorPosition(cursorPostion: (rangeArr![i]["range"] as? NSRange)!.length+(rangeArr![i]["range"] as? NSRange)!.location) //+1 has been removed here, need to understand why it was added
                    self.hashtagInsertionTag = -1
                } else{
                    self.setCurrentCursorPosition(cursorPostion: (rangeArr![i]["range"] as? NSRange)!.length+(rangeArr![i]["range"] as? NSRange)!.location)
                    self.hashtagInsertionTag = -1
                }
            }
            for i in 0...(rangeArr?.count)!-1 where currentCursor == (rangeArr![i]["range"] as? NSRange)!.location+1{
                if showDeleteAttachment && rangeArr![i]["type"]! as? String == "post"{
                    self.delegate?.showSharedPostDeleteConfirmation()
                }
                showDeleteAttachment = true
            }
        }
        if getCurrentCursorPostion() == 0{
            
        } else{
            if !isAtTheRatePressed{
                isAtTheRatePressed = false
                let stringArr = textView.text.substring(to: getCurrentCursorPostion()-1)
                let strnew = stringArr.components(separatedBy: " ").last
                let newTemp = strnew?.components(separatedBy: "\n")
                self.searchString = (newTemp?.last)!
                if self.searchString.first == "#"{
                    self.hashtagInsertionTag = 1
                    self.hashtagRange = NSRange(location: getCurrentCursorPostion()-2-self.searchString.count, length: 0)
                }
            }
        }
        guard let temp = UserDefaults.standard.object(forKey: "isContentSharing") as? Bool else{
            return
        }
        if temp{
            adjustFramesTextView()
        }
    }
    func getCurrentCursorPostion() -> Int {
        if let selectedRange = textviewEditMode?.selectedTextRange {
            let cursorPosition = textviewEditMode?.offset(from: (textviewEditMode?.beginningOfDocument)!, to: selectedRange.start)
            //print("\(cursorPosition!)")
            return cursorPosition!
        }
        return 0
    }
    func setCurrentCursorPosition(cursorPostion:Int) {
        let arbitraryValue: Int = cursorPostion
        if let newPosition = textviewEditMode?.position(from: (textviewEditMode?.beginningOfDocument)!, offset: arbitraryValue) {
            textviewEditMode?.selectedTextRange = textviewEditMode?.textRange(from: newPosition, to: newPosition)
        }
    }
    
    func setCurrentCursorPositionToEnd() {
        let newPosition = textviewEditMode?.endOfDocument
        textviewEditMode?.selectedTextRange = textviewEditMode?.textRange(from: newPosition!, to: newPosition!)
    }
    
    func attherateClicked() {
        //textviewEditMode?.isHashtagAttheRateInserted = true
        isAtTheRatePressed = true
        if (textviewEditMode?.textString?.length ?? 0) >= textCount{
            UIApplication.shared.windows.last?.makeToast(NSLocalizedString("post_write_alert_01", comment: ""))
            return
        }
        delegate?.enableRightButton()
        textviewEditMode?.becomeFirstResponder()
        searchString = "@"
        self.insertionIndex = getCurrentCursorPostion()
        if placeholderShow{
            placeholderShow = false
            textviewEditMode?.text = ""
        }
        checking()
        let strtemp = NSString(string: (textviewEditMode?.text)!)
        textviewEditMode?.attrString?.insert("@".attributedString, at: getCurrentCursorPostion())
        let temp = strtemp.replacingCharacters(in: NSRange(location: getCurrentCursorPostion(), length: 0), with: "@")
        if temp == nil{
            textviewEditMode?.textString = "@"
            textviewEditMode?.text = "@"
            let mutableStr = NSMutableAttributedString(string: (textviewEditMode?.text)!)
            textviewEditMode?.setAttrWithoutSpace(word: mutableStr, text: "@", font: Fp_s26.font, cursorPostion: getCurrentCursorPostion())
        } else{
            textviewEditMode?.textString = NSString(string: temp)
            textviewEditMode?.text = temp
            self.setCurrentCursorPosition(cursorPostion: self.insertionIndex+1)
            let mutableStr = NSMutableAttributedString(string: (textviewEditMode?.text)!)
            checkingforAttachment()
            textviewEditMode?.setAttrWithoutSpace(word: mutableStr, text: temp, font: Fp_s26.font, cursorPostion: getCurrentCursorPostion())
        }
        
        if temp != nil && getCurrentCursorPostion()>1{
            if (NSString(string: temp).substring(to: getCurrentCursorPostion()-1).last! == " " || NSString(string: temp).substring(to: getCurrentCursorPostion()-1).last! == "\n"){
                delegate?.cancelPreviousAPICall()
                delegate?.attheRatePressed(str: searchString)
                //textviewEditMode?.checkPlaceholder()
                self.checkingPlaceholderAndSaveButton(txtView: textviewEditMode!)
            } else{
                searchString = ""
                self.insertionIndex = -1
            }
        } else{
            delegate?.cancelPreviousAPICall()
            delegate?.attheRatePressed(str: searchString)
            //textviewEditMode?.checkPlaceholder()
            self.checkingPlaceholderAndSaveButton(txtView: textviewEditMode!)
        }
    }
    
    func hashtagClicked() {
        isAtTheRatePressed = true
        if (textviewEditMode?.textString?.length ?? 0) >= textCount{
            UIApplication.shared.windows.last?.makeToast(NSLocalizedString("post_write_alert_01", comment: ""))
            return
        }
        self.hashtagInsertionTag = getCurrentCursorPostion()
        delegate?.enableRightButton()
        textviewEditMode?.becomeFirstResponder()
        if placeholderShow{
            placeholderShow = false
            textviewEditMode?.text = ""
        }
        checking()
        let str = textviewEditMode?.textString
        textviewEditMode?.attrString?.insert("#".attributedString, at: getCurrentCursorPostion())
        let temp = str?.replacingCharacters(in: NSRange(location: getCurrentCursorPostion(), length: 0), with: "#")
        if temp == nil{
            textviewEditMode?.textString = "#"
            textviewEditMode?.text = "#"
            let mutableStr = NSMutableAttributedString(string: (textviewEditMode?.text)!)
            textviewEditMode?.setAttrWithoutSpace(word: mutableStr, text: "#", font: Fp_s26.font, cursorPostion: getCurrentCursorPostion())
        } else{
            textviewEditMode?.textString = NSString(string: temp!)
            textviewEditMode?.text = temp
            self.setCurrentCursorPosition(cursorPostion: self.hashtagInsertionTag+1)
            let mutableStr = NSMutableAttributedString(string: (textviewEditMode?.text)!)
            checkingforAttachment()
            textviewEditMode?.setAttrWithoutSpace(word: mutableStr, text: temp!, font: Fp_s26.font, cursorPostion: getCurrentCursorPostion())
        }
        self.hashtagInsertionTag = 1
        //textviewEditMode?.checkPlaceholder()
        self.checkingPlaceholderAndSaveButton(txtView: textviewEditMode!)

        //        let rangeNew:NSRange?
        //        rangeNew = NSString(string: (self.textviewEditMode?.text)!).range(of: str!, options: [], range: finalRange)
        //_ = self.textView(textviewEditMode!, shouldChangeTextIn: NSRange(location: getCurrentCursorPostion(), length: 0), replacementText: "#")
        if !searchString.isEmpty && insertionIndex != -1{
            self.searchString += "#"
            searchString = String(searchString.dropFirst())
            delegate?.cancelPreviousAPICall()
            delegate?.attheRatePressed(str: searchString)
            //                textviewEditMode?.checkPlaceholder()
            self.checkingPlaceholderAndSaveButton(txtView: textviewEditMode!)
        }
    }
    
}
