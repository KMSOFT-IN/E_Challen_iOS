//
//  String.swift
//  buddyUpppp
//
//  Created by KMSOFT on 07/07/21.
//
//
//import UIKit
//import Foundation
//
//fileprivate let badChars = CharacterSet.alphanumerics.inverted
//extension String {
//    func trim() -> String {
//        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
//    }
//    
//    var isAlphanumericAndUnderscope: Bool {
//        return !isEmpty && range(of: "[^a-zA-Z0-9_.]", options: .regularExpression) == nil
//    }
//    
//    func getDate() -> Date? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = appFullDateFormat
//        let date = dateFormatter.date(from: self)
//        return date
//    }
//    
//    func getDictionary() -> [String: Any]? {
//        if let data = self.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }
//    
//    var uppercasingFirst: String {
//        return prefix(1).uppercased() + dropFirst()
//    }
//    
//    var lowercasingFirst: String {
//        return prefix(1).lowercased() + dropFirst()
//    }
//    
//    var camelCased: String {
//        guard !isEmpty else {
//            return ""
//        }
//        
//        let parts = self.components(separatedBy: badChars)
//        
//        let first = String(describing: parts.first!).lowercasingFirst
//        let rest = parts.dropFirst().map({String($0).uppercasingFirst})
//        
//        return ([first] + rest).joined(separator: "")
//    }
//    
//    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
//        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
//        for index in 0 ..< pattern.count {
//            guard index < pureNumber.count else { return pureNumber }
//            let stringIndex = String.Index(utf16Offset: index, in: self)
//            let patternCharacter = pattern[stringIndex]
//            guard patternCharacter != replacmentCharacter else { continue }
//            pureNumber.insert(patternCharacter, at: stringIndex)
//        }
//        return pureNumber
//    }
//}
//
//extension NSMutableAttributedString {
//    var fontSize: CGFloat { return 14 }
//    var boldFont: UIFont { return UIFont.boldSystemFont(ofSize: UIFont.systemFontSize) }
//    var normalFont: UIFont { return UIFont.systemFont(ofSize: UIFont.systemFontSize) }
//    
//    func bold(_ value: String, font: UIFont? = nil) -> NSMutableAttributedString {
//        
//        let attributes:[NSAttributedString.Key : Any] = [
//            .font : font ?? boldFont
//        ]
//        
//        self.append(NSAttributedString(string: value, attributes:attributes))
//        return self
//    }
//    
//    func normal(_ value:String, font: UIFont? = nil) -> NSMutableAttributedString {
//        
//        let attributes:[NSAttributedString.Key : Any] = [
//            .font : font ?? normalFont,
//        ]
//        
//        self.append(NSAttributedString(string: value, attributes:attributes))
//        return self
//    }
//    
//    /* Other styling methods */
//    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
//        
//        let attributes:[NSAttributedString.Key : Any] = [
//            .font :  normalFont,
//            .foregroundColor : UIColor.white,
//            .backgroundColor : UIColor.orange
//        ]
//        
//        self.append(NSAttributedString(string: value, attributes:attributes))
//        return self
//    }
//    
//    func blackHighlight(_ value:String) -> NSMutableAttributedString {
//        
//        let attributes:[NSAttributedString.Key : Any] = [
//            .font :  normalFont,
//            .foregroundColor : UIColor.white,
//            .backgroundColor : UIColor.black
//            
//        ]
//        
//        self.append(NSAttributedString(string: value, attributes:attributes))
//        return self
//    }
//    
//    func underlined(_ value:String) -> NSMutableAttributedString {
//        let attributes:[NSAttributedString.Key : Any] = [
//            .font :  normalFont,
//            .underlineStyle : NSUnderlineStyle.single.rawValue
//        ]
//        
//        self.append(NSAttributedString(string: value, attributes:attributes))
//        return self
//    }
//    
//    func link(_ text: String, url: URL) -> NSMutableAttributedString {
//        let attributes:[NSAttributedString.Key : Any] = [
//            .font: normalFont,
//            .link: url
//        ]
//        
//        self.append(NSAttributedString(string: text, attributes:attributes))
//        return self
//    }
//}
//
//extension String {
//    func deletingPrefix(_ prefix: String) -> String {
//        guard self.hasPrefix(prefix) else { return self }
//        return String(self.dropFirst(prefix.count))
//    }
//    
//    func removeSuffix(_ suffix: String) -> String {
//        guard self.hasSuffix(suffix) else { return self }
//        return String(self.dropLast(suffix.count))
//    }
//}
//
//extension String {
//    var bool: Bool? {
//        switch self.lowercased() {
//        case "true", "t", "yes", "y":
//            return true
//        case "false", "f", "no", "n", "":
//            return false
//        default:
//            if let int = Int(self) {
//                return int != 0
//            }
//            return nil
//        }
//    }
//}
