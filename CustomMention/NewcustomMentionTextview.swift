//
//  customMentionTextview.swift
//  EFSS
//
//  Created by Nagmani Singh on 28/02/19.
//  Copyright © 2019 Durgesh. All rights reserved.
//

import UIKit
public protocol NewcustomMentionTextviewDelegate: class {
    func attheRatePressed(str:String)
    func dynamicHeightTextview(value:CGFloat)
    func showScrollIndicator()
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

public class NewcustomMentionTextview: UIView, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
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
    public weak var delegate: NewcustomMentionTextviewDelegate?
    var timerForShowScrollIndicator: Timer?
    var widthOfBlank : CGFloat = 0.0
    var showDeleteAttachment = true
    var isAtTheRatePressed = false
    let textCount = 10000
    public var myArray: [String] = ["First","Second","Third"]
    public var myTableView: UITableView!
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
        textviewEditMode?.textColor = fp_s59.color
        textviewEditMode?.font = fp_s59.font
        textviewEditMode?.delegate = self
        //textviewEditMode?.autocorrectionType = .no
        textviewEditMode?.backgroundColor = fp_s16.color
        self.addSubview(textviewEditMode!)
        
        myTableView = UITableView(frame: CGRect(x: 0, y: 50, width: 300, height: 100))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.layer.borderWidth = 1.0
        myTableView.layer.borderColor = UIColor.lightGray.cgColor
        self.addSubview(myTableView)
        hideMentionSuggestion(value: true)
    }
    
    public func hideMentionSuggestion(value:Bool) {
        myTableView.isHidden = value
        if !value{
            self.showTableSuggestions()
        }
    }
    
    private func showTableSuggestions() {
        if let cursorPosition = textviewEditMode?.selectedTextRange?.start {
            let caretPositionRectangle: CGRect = (textviewEditMode?.caretRect(for: cursorPosition))!
            // now use either the whole rectangle, or its origin (caretPositionRectangle.origin)
            print(caretPositionRectangle)
            if caretPositionRectangle.origin.y>138.0{
                self.myTableView.frame.origin.y = 0.0
            } else{
                let temp = caretPositionRectangle.origin.y+30.0
                self.myTableView.frame.origin.y = temp
            }
            self.bringSubview(toFront: self.myTableView)
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.returnedStringAPI(returnedString: myArray[indexPath.row])
        self.hideMentionSuggestion(value: true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(myArray[indexPath.row])"
        return cell
    }
    
    public func setplaceholder(str:String){
        textviewEditMode?.setPlaceholderNew(localizeValue: str)
    }
    
    public class func instanceFromNib() -> NewcustomMentionTextview {
        return (UINib(nibName: "NewcustomMentionTextview", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? NewcustomMentionTextview)!
    }
    
    func setTextTempNew(str:[PostContentType]) {
        textviewEditMode?.setTextNew(text: str, andMentionColor: Fp_s29.color, font: fp_s26.font, hashtagFont: Fp_s32.font, mentiontagFont: Fp_s29.font, strArray: self.tempArrayDemo, cursorPostion: self.getCurrentCursorPostion())
            self.setCurrentCursorPositionToEnd()
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
                }
            }
            print(parts)
            self.textviewEditMode?.partArray = parts
        }
    }
    
   public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == fp_s59.color && placeholderShow {
            placeholderShow = false
            textView.text = nil
            textView.textColor = UIColor.black
        }
        if textView.text.isEmpty {
            textView.text = ""
            self.checkingPlaceholderAndSaveButton(txtView: textView)
        }
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ""
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
        let fixedWidth = textviewEditMode?.frame.size.width
        let newSize = textviewEditMode?.sizeThatFits(CGSize(width: fixedWidth!, height: CGFloat.greatestFiniteMagnitude))
        delegate?.dynamicHeightTextview(value: (newSize?.height)! > 134.0 ? ((newSize?.height)!+20) : 134.0)
        textviewEditMode?.frame.size = CGSize(width: max((newSize?.width)!, fixedWidth!), height: (newSize?.height)! > 134.0 ? ((newSize?.height)!+20) : 134.0)
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        self.checkingPlaceholderAndSaveButton(txtView: textView)
        if self.searchString.isEmpty{
        }
        if textView.text.count + (text.count - range.length) >= textCount{
            UIApplication.shared.windows.last?.makeToast(NSLocalizedString("post_write_alert_01", comment: ""))
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
            self.hideMentionSuggestion(value: true)
            return true
        }
        let updatedText = currentText.replacingCharacters(in: range, with: text) as NSString
        if updatedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            self.insertionIndex = -1
            self.hashtagInsertionTag = -1
            searchString = ""
            self.hideMentionSuggestion(value: true)
            //return true
        } else{
        }
        self.checking()
        //handling backspace for mention hashtag and url
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        // handling backspace
        if isBackSpace == -92{
            self.hideMentionSuggestion(value: true)
            let rangeArr = self.textviewEditMode?.rangeArray
            if (rangeArr?.count)!>0{
                for i in 0...(rangeArr?.count)!-1 where (rangeArr![i]["range"] as? NSRange)!.length+(rangeArr![i]["range"] as? NSRange)!.location == range.location+range.length && rangeArr![i]["type"]! as? String != "post"{
                    let totalAttrStr = self.textviewEditMode?.attributedText
                    let totalMuatble:NSMutableAttributedString = NSMutableAttributedString.init(attributedString: totalAttrStr!)
                    totalMuatble.deleteCharacters(in: (rangeArr![i]["range"] as? NSRange)!)
                    if totalMuatble.string.isEmpty || totalMuatble.string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
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
            self.hideMentionSuggestion(value: true)
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
            self.hideMentionSuggestion(value: true)
        }
        self.adjustFramesTextView()
        return true
    }
    func returnedStringAPI(returnedString:String)  {
        showDeleteAttachment = false
        if self.insertionIndex == -1{
            self.hideMentionSuggestion(value: true)
        } else{
            let finalRange = NSRange(location: self.insertionIndex, length: NSString(string: (self.textviewEditMode?.text)!).length-self.insertionIndex)
            var str = ""
            if self.getCurrentCursorPostion() < self.insertionIndex{
                
            } else{
                str = (self.textviewEditMode?.textString?.substring(with: NSRange(location: self.insertionIndex, length: self.getCurrentCursorPostion()-self.insertionIndex)))!
            }
            let rangeNew:NSRange?
            if str == "@"{
                rangeNew = NSString(string: (self.textviewEditMode?.text)!).range(of: str, options: [], range: finalRange)
            } else{
                rangeNew = NSString(string: (self.textviewEditMode?.text)!).range(of: str, options: [], range: finalRange)
            }
            if rangeNew?.location == NSNotFound{
                self.hideMentionSuggestion(value: true)
                self.searchString = ""
            } else{
                let totalAttrStr = self.textviewEditMode?.attributedText
                let totalMuatble:NSMutableAttributedString = NSMutableAttributedString.init(attributedString: totalAttrStr!)
                totalMuatble.replaceCharacters(in: rangeNew!, with: returnedString+" ")
                self.textviewEditMode?.setAttrWithWordMention(word: totalMuatble, range: rangeNew!, color: Fp_s29.color, text: returnedString, font: Fp_s29.font, attrName: returnedString, cursorPostion: self.getCurrentCursorPostion())
                self.hideMentionSuggestion(value: true)
                self.setCurrentCursorPosition(cursorPostion: self.insertionIndex+returnedString.count+1)
                self.searchString = ""
                self.checking()
                self.textviewEditMode?.setAttrWithoutSpace(word: totalMuatble, text: totalMuatble.string, font: Fp_s26.font, cursorPostion: self.insertionIndex+returnedString.count+1)
                self.insertionIndex = -1
            }
        }
        self.adjustFramesTextView()
    }
    public func textViewDidChange(_ textView: UITextView) {
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
        } else{
            if txtView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            } else{
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
    
}
