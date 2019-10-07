//
//  ColorExtensions.swift
//  EFSS
//
//  Created by Dhairya on 07/09/18.
//  Copyright © 2018 Asif. All rights reserved.
//

import Foundation
import UIKit
struct FontDetails {
    var color: UIColor
    var size: Double
    var style: String
    var font: UIFont
    init(codingDict: [String: Any]) {
        guard
            let color = codingDict["color"] as? String,
            let size = codingDict["size"] as? Double,
            let opacity = codingDict["opacity"] as? Double,
            let style = codingDict["style"] as? String
            else {
                self.color = .white
                self.size = 20.0
                self.style = "Regular"
                self.font = UIFont.systemFont(ofSize: CGFloat(self.size))
                return
        }
        self.color = color.hexStringToUIColor(opacity: CGFloat(opacity))
        self.size = size
        self.style = style
        switch style {
        case "Bold":
            self.font = UIFont.systemFont(ofSize: CGFloat(size), weight: .bold)
        default:
            self.font = UIFont.systemFont(ofSize: CGFloat(size), weight: .regular)
        }
    }
}
let fc1 = FontDetails.init(codingDict: ["color": "fafafa", "size": 20.0, "opacity": 1.0, "style": "Regular"])
let fc2 = FontDetails.init(codingDict: ["color": "fafafa", "size": 15.0, "opacity": 1.0, "style": "Regular"])
let fc3 = FontDetails.init(codingDict: ["color": "fafafa", "size": 15.0, "opacity": 0.4, "style": "Regular"])
let fc6 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.2, "style": "Regular"])
let fc7 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.8, "style": "Regular"])
let fc8 = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.6, "style": "Regular"])
let fc9 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.8, "style": "Bold"])
let fc10 = FontDetails.init(codingDict: ["color": "0e85dd", "size": 16.0, "opacity": 1.0, "style": "Bold"])
let fc11 = FontDetails.init(codingDict: ["color": "0e85dd", "size": 16.0, "opacity": 1.0, "style": "Regular"])
let fc12 = FontDetails.init(codingDict: ["color": "000000", "size": 12.0, "opacity": 0.6, "style": "Regular"])
let fc13 = FontDetails.init(codingDict: ["color": "000000", "size": 12.0, "opacity": 0.4, "style": "Regular"])
let fc14 = FontDetails.init(codingDict: ["color": "7f7f7f", "size": 12.0, "opacity": 1.0, "style": "Regular"])
let fc15 = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.8, "style": "Regular"])
let fc16 = FontDetails.init(codingDict: ["color": "fafafa", "size": 18.0, "opacity": 1.0, "style": "Regular"])
let fc17 = FontDetails.init(codingDict: ["color": "000000", "size": 17.0, "opacity": 0.8, "style": "Regular"])
let fr3 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.9, "style": "Regular"])
let ft9 = FontDetails.init(codingDict: ["color": "000000", "size": 16.5, "opacity": 0.9, "style": "Medium"])
let fc53 = FontDetails.init(codingDict: ["color": "518cdb", "size": 14.0, "opacity": 0.8, "style": "Bold"])
let fw2 = FontDetails.init(codingDict: ["color": "0e85dd", "size": 12.0, "opacity": 1.0, "style": "Regular"])
let fw3 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.4, "style": "Regular"])
let fw8 = FontDetails.init(codingDict: ["color": "FA902D", "size": 12.0, "opacity": 1.0, "style": "Regular"])
let fc31 = FontDetails.init(codingDict: ["color": "0e85dd", "size": 14.0, "opacity": 1.0, "style": "Regular"])
let fc55 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.6, "style": "Regular"])
let fc54 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.8, "style": "Bold"])
let fp_s2 = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.8, "style": "Bold"])
let fc32 = FontDetails.init(codingDict: ["color": "fafafa", "size": 12.0, "opacity": 0.4, "style": "Regular"])
let fc36 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.6, "style": "Regular"])

let fc28 = FontDetails.init(codingDict: ["color": "fafafa", "size": 16.0, "opacity": 1.0, "style": "Regular"])
let fi3 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.6, "style": "Regular"])
let fc56 = FontDetails.init(codingDict: ["color": "000000", "size": 12.0, "opacity": 0.3, "style": "Regular"])
let fd5 = FontDetails.init(codingDict: ["color": "000000", "size": 12.0, "opacity": 0.8, "style": "Regular"])
let fC84 = FontDetails.init(codingDict: ["color": "ffffff", "size": 15.0, "opacity": 0.4, "style": "Regular"]) //  Switch On/Off Text
let fp_s5 = FontDetails.init(codingDict: ["color": "000000", "size": 15.0, "opacity": 0.8, "style": "Bold"]) // Post First Name
let fp_s6 = FontDetails.init(codingDict: ["color": "000000", "size": 15.0, "opacity": 0.6, "style": "Regular"]) // Posts Partner type
let fp_s7 = FontDetails.init(codingDict: ["color": "000000", "size": 12.0, "opacity": 0.4, "style": "Regular"]) // Posts timeStamp
let fp_s8 = FontDetails.init(codingDict: ["color": "0e85dd", "size": 14.0, "opacity": 1.0, "style": "Bold"]) // posts HashTag UnRead
let fp_s9 = FontDetails.init(codingDict: ["color": "0e85dd", "size": 14.0, "opacity": 1.0, "style": "Regular"])  // posts HashTag Read
let fp_s43 = FontDetails.init(codingDict: ["color": "359feb", "size": 12.0, "opacity": 1.0, "style": "Regular"]) // Posts hashtag count
let fp_s10 = FontDetails.init(codingDict: ["color": "000000", "size": 15.0, "opacity": 0.8, "style": "Bold"]) // Posts desc UnRead
let fp_s11 = FontDetails.init(codingDict: ["color": "000000", "size": 15.0, "opacity": 0.8, "style": "Regular"]) // Posts desc Read
let ff3 = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.6, "style": "Medium"]) // Posts last activity
let ff4 = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.4, "style": "Medium"]) // Posts comment Count
let fp_s15 = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.8, "style": "Regular"]) // Posts summary Status default
let fp_s16 = FontDetails.init(codingDict: ["color": "ffffff", "size": 12.0, "opacity": 1.0, "style": "Regular"]) // Posts Summary status edited
let fp_s26 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.8, "style": "Regular"])
let Fp_s14 = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.4, "style": "Regular"])
let Fp_s31 = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.4, "style": "Bold"]) // workspace count in post details
let fp_s45 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.8, "style": "Regular"])
let fp_s44 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.4, "style": "Regular"])
let fp_s31 = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.4, "style": "Bold"])
let Fp_s32 = FontDetails.init(codingDict: ["color": "0e85dd", "size": 16.0, "opacity": 1.0, "style": "Regular"]) // # Tags Text Color
let Fp_s29 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.8, "style": "Bold"]) // # Post user Name Or Workspace Text Color
let Fp_s26 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.8, "style": "Regular"]) //  post detail TextwithTag Cell normal text color
let Fp_s33 = FontDetails.init(codingDict: ["color": "0e85dd", "size": 16.0, "opacity": 1.0, "style": "Regular"])  // URL color
let fp_s38 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.8, "style": "Regular"])  // URL color
let fp_s37 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.4, "style": "Regular"])  // attachment disabled color
let fp_s1 = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.6, "style": "Regular"])  // Likes area
let ff38 = FontDetails.init(codingDict: ["color": "0e85dd", "size": 14.0, "opacity": 1.0, "style": "Regular"]) // File No Authority SOP
let ff6 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.4, "style": "Regular"]) // File No Authority : File Name
let fc_d6 = FontDetails.init(codingDict: ["color": "000000", "size": 12.0, "opacity": 0.2, "style": "Regular"]) // File No Authority : File detail
let ff28 = FontDetails.init(codingDict: ["color": "ee8945", "size": 16.0, "opacity": 1.0, "style": "Regular"])
let ff39 = FontDetails.init(codingDict: ["color": "ee8945", "size": 16.0, "opacity": 0.5, "style": "Regular"])
let fc50 = FontDetails.init(codingDict: ["color": "000000", "size": 12.0, "opacity": 0.6, "style": "Regular"])
let fp1 = FontDetails.init(codingDict: ["color": "000000", "size": 20.0, "opacity": 0.8, "style": "Regular"])
let fp1_bold = FontDetails.init(codingDict: ["color": "000000", "size": 20.0, "opacity": 0.8, "style": "Bold"])
let ff27 = FontDetails.init(codingDict: ["color": "8bc34a", "size": 16.0, "opacity": 1.0, "style": "Regular"])
let ff29 = FontDetails.init(codingDict: ["color": "ed4839", "size": 16.0, "opacity": 1.0, "style": "Regular"])
let ff31 = FontDetails.init(codingDict: ["color": "0e85dd", "size": 16.0, "opacity": 0.8, "style": "Regular"])
let fp_s12 = FontDetails.init(codingDict: ["color": "000000", "size": 12.0, "opacity": 0.6, "style": "Regular"])
let btn_s4_normal = FontDetails.init(codingDict: ["color": "0e84dd", "size": 13.0, "opacity": 1.0, "style": "Regular"])
let btn_s4_pressed = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.2, "style": "Regular"])
let btn_s2_noneFont =  FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.4, "style": "Regular"])
let btn_s3_normal = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.8, "style": "Regular"])
let btn_s3_disable = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.2, "style": "Regular"])
let ff10 = FontDetails.init(codingDict: ["color": "0e85dd", "size": 12.0, "opacity": 1.0, "style": "Regular"])
let fc21 = FontDetails.init(codingDict: ["color": "000000", "size": 12.0, "opacity": 0.8, "style": "Regular"])
let fp_s84 = FontDetails.init(codingDict: ["color": "000000", "size": 12.0, "opacity": 0.6, "style": "Bold"])
let fp_s86 = FontDetails.init(codingDict: ["color": "ff5253", "size": 16.0, "opacity": 1.0, "style": "Regular"])
let fp2 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.6, "style": "Regular"])
let btn_normal4 = FontDetails.init(codingDict: ["color": "518cdb", "size": 16.0, "opacity": 1.0, "style": "Regular"])
let fc_37 = FontDetails.init(codingDict: ["color": "000000", "size": 11.0, "opacity": 0.5, "style": "Regular"]) // File No Authority : File detail
let copyRightColor = FontDetails.init(codingDict: ["color": "000000", "size": 11.0, "opacity": 0.6 , "style": "Regular"])
let versionDet = FontDetails.init(codingDict: ["color": "2a96fd", "size": 14.0, "opacity": 1.0 , "style": "Regular"])
let ff8 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.8 , "style": "Regular"])
let screenLockPwd = FontDetails.init(codingDict: ["color": "000000", "size": 24.0, "opacity": 0.8, "style": "Regular"])
let screenLockError = FontDetails.init(codingDict: ["color": "ff3333", "size": 15.0, "opacity": 0.8, "style": "Regular"])
let screenLockPwdNumbers = FontDetails.init(codingDict: ["color": "000000", "size": 33.0, "opacity": 0.9, "style": "Medium"])

let fp_s30 = FontDetails.init(codingDict: ["color": "0e85dd", "size": 13.0, "opacity": 1.0, "style": "Regular"])

let btn_s2_PollNone = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.3, "style": "Regular"])
let btn_s2_PollVoted = FontDetails.init(codingDict: ["color": "359feb", "size": 13.0, "opacity": 0.1, "style": "Regular"])
let btn_s2_PollMost = FontDetails.init(codingDict: ["color": "f6b40e", "size": 13.0, "opacity": 1.0, "style": "Regular"])
let Fp_s34 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.6, "style": "Regular"])  // URL color
let fn2 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.4, "style": "Regular"])
let fr2 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.6, "style": "Regular"])
let fd2 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.8, "style": "Regular"])
let btn2_normal = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.8, "style": "Regular"])
let fi1 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.8, "style": "Bold"])
let ff7 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.3, "style": "Regular"])
let profilePicLabel = FontDetails.init(codingDict: ["color": "fafafa", "size": 40.0, "opacity": 1.0, "style": "Regular"])
let profilePicLabelForSettings = FontDetails.init(codingDict: ["color": "fafafa", "size": 22.0, "opacity": 1.0, "style": "Regular"])
let btn_s1_normal = FontDetails.init(codingDict: ["color": "518cdb", "size": 15.0, "opacity": 1.0, "style": "Regular"])
let btn_s1_Disable = FontDetails.init(codingDict: ["color": "000000", "size": 15.0, "opacity": 0.8, "style": "Regular"])
let Fp_s41 = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.6, "style": "Regular"])  // URL color
let Fp_s40 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.4, "style": "Regular"])
let fp_s49 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.4, "style": "Regular"])
let fp_s50 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.8, "style": "Regular"])
let Fp_s28 = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.6, "style": "Regular"]) //  post detail TextwithTag Cell normal text color
let fp_s27 = FontDetails.init(codingDict: ["color": "359feb", "size": 13.0, "opacity": 1.0, "style": "Regular"])
let fc_Search = FontDetails.init(codingDict: ["color": "fafafa", "size": 20.0, "opacity": 0.2, "style": "Regular"])
let fc_RecentSearch = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.8, "style": "Bold"])
let barColor = FontDetails.init(codingDict: ["color": "359feb", "size": 12.0, "opacity": 0.5, "style": "Regular"]) // Posts hashtag count
let bt1_normal = FontDetails.init(codingDict: ["color": "518cdb", "size": 14.0, "opacity": 1.0, "style": "Regular"])
let btn_NonPrimary = FontDetails.init(codingDict: ["color": "000000", "size": 13.0, "opacity": 0.8, "style": "Regular"])
let Fp_s68 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.9, "style": "Regular"])
let Fp_s36 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.4, "style": "Regular"])
let Fp_s35 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.8, "style": "Regular"])
let fc83 = FontDetails.init(codingDict: ["color": "ffffff", "size": 15.0, "opacity": 0.8, "style": "Regular"])

// Edit floating Button
let edit_Normal = FontDetails.init(codingDict: ["color": "8bc34a", "size": 15.0, "opacity": 0.92, "style": "Regular"])
let edit_Pressed = FontDetails.init(codingDict: ["color": "7daf42", "size": 15.0, "opacity": 0.92, "style": "Regular"])

// WSList
let fp_s57 = FontDetails.init(codingDict: ["color": "000000", "size": 14.0, "opacity": 0.6, "style": "Regular"]) // Workspace (empty) adding an workspace
let fp_s58 = FontDetails.init(codingDict: ["color": "359feb", "size": 14.0, "opacity": 0.8, "style": "Regular"])  // topic color
let fp_s59 = FontDetails.init(codingDict: ["color": "000000", "size": 16.0, "opacity": 0.4, "style": "Regular"])  // topic color
let fp_s60 = FontDetails.init(codingDict: ["color": "ee8945", "size": 12.0, "opacity": 1.0, "style": "Regular"])  // topic color
let ft2 = FontDetails.init(codingDict: ["color": "0e85dd", "size": 17.0, "opacity": 1.0, "style": "Medium"])
let ft1 = FontDetails.init(codingDict: ["color": "000000", "size": 17.0, "opacity": 0.8, "style": "Medium"])

let btn_line_normal1 = FontDetails.init(codingDict: ["color": "000000", "size": 12.0, "opacity": 0.8, "style": "Regular"])
let fp_dp4 = FontDetails.init(codingDict: ["color": "000000", "size": 11.0, "opacity": 0.4, "style": "Regular"])
let fc20 = FontDetails.init(codingDict: ["color": "000000", "size": 20.0, "opacity": 0.8, "style": "Regular"])
let regexValidURL = "^(http|https|ftp)\\://([a-zA-Z0-9\\.\\-]+(\\:[a-zA-Z0-9\\.&amp%\\$\\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|localhost|([a-zA-Z0-9\\-]+\\.)*[a-zA-Z0-9\\-]+\\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\\:[0-9]+)*(/($|[a-zA-Z0-9\\.\\,\\?\\'\\\\\\+&amp%\\$#\\=~_\\-]+))*$"

extension UITextView{
    public func setPlaceholderNew(localizeValue:String) {
        let placeholderLabel = UILabel()
        placeholderLabel.text =  localizeValue
        placeholderLabel.font = fc6.font
        placeholderLabel.textColor = fc6.color
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.numberOfLines = 0
        let width = frame.width - textContainer.lineFragmentPadding * 2
        let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        placeholderLabel.frame.size.height = size.height
        placeholderLabel.frame.size.width = width
        placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)
        placeholderLabel.isHidden = !self.text.isEmpty
        self.addSubview(placeholderLabel)
    }
    public func checkPlaceholderNew() -> Bool {
        let placeholderLabel = self.viewWithTag(222) as? UILabel
        placeholderLabel?.isHidden = !self.text.isEmpty
        return self.text.isEmpty
    }
    public func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(222) as? UILabel
        placeholderLabel?.isHidden = !self.text.isEmpty
    }
}
extension String{
   public func checkForHashtag(str:String) -> Bool {
        let regExOne = "#[0-9a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regExOne])
        if predicate.evaluate(with: str.lowercased()){
            return true
        }
        return false
    }
    public func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    public func canOpenURL(string: String?) -> Bool {
        let urlRegEx = regexValidURL
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: string)
        return result
    }
    public func hexStringToUIColor (opacity: CGFloat) -> UIColor {
        var cString: String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: opacity
        )
    }
    public func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }
    public func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
}
