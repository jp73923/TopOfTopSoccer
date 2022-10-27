//
//  UILabelExtensions.swift
//  CookerApp
//
//  Created by Admin on 27/12/17.
//  Copyright © 2017 EL. All rights reserved.
//

import Foundation
import UIKit

public extension UILabel
{
    func addLabelLeftPadding(_ image: UIImage,Text:String)
    {
        let imageAttachment =  NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(x: -10, y: -10, width: image.size.width, height: image.size.height)
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let  textAfterIcon = NSMutableAttributedString(string: " " + Text)
        completeText.append(textAfterIcon)
        self.textAlignment = .left;
        self.attributedText = completeText;
    }
    func applyGradientWith(startColor: UIColor, endColor: UIColor) -> Bool {
        
        var startColorRed:CGFloat = 0
        var startColorGreen:CGFloat = 0
        var startColorBlue:CGFloat = 0
        var startAlpha:CGFloat = 0
        
        if !startColor.getRed(&startColorRed, green: &startColorGreen, blue: &startColorBlue, alpha: &startAlpha) {
            return false
        }
        
        var endColorRed:CGFloat = 0
        var endColorGreen:CGFloat = 0
        var endColorBlue:CGFloat = 0
        var endAlpha:CGFloat = 0
        
        if !endColor.getRed(&endColorRed, green: &endColorGreen, blue: &endColorBlue, alpha: &endAlpha) {
            return false
        }
        
        let gradientText = self.text ?? ""
        
        let name:String = NSAttributedString.Key.font.rawValue
        let textSize: CGSize = gradientText.size(withAttributes: [NSAttributedString.Key(rawValue: name):self.font!])
        let width:CGFloat = textSize.width
        let height:CGFloat = textSize.height
        
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return false
        }
        
        UIGraphicsPushContext(context)
        
        let glossGradient:CGGradient?
        let rgbColorspace:CGColorSpace?
        let num_locations:size_t = 2
        let locations:[CGFloat] = [ 0.0, 1.0 ]
        let components:[CGFloat] = [startColorRed, startColorGreen, startColorBlue, startAlpha, endColorRed, endColorGreen, endColorBlue, endAlpha]
        rgbColorspace = CGColorSpaceCreateDeviceRGB()
        glossGradient = CGGradient(colorSpace: rgbColorspace!, colorComponents: components, locations: locations, count: num_locations)
        let topCenter = CGPoint.zero
        let bottomCenter = CGPoint(x: 0, y: textSize.height)
        context.drawLinearGradient(glossGradient!, start: topCenter, end: bottomCenter, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        
        UIGraphicsPopContext()
        
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return false
        }
        
        UIGraphicsEndImageContext()
        
        self.textColor = UIColor(patternImage: gradientImage)
        
        return true
    }
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font!], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }    
}



extension UILabel {
    func sizeToFitHeight() {
        let tempLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
        tempLabel.numberOfLines = numberOfLines
        tempLabel.lineBreakMode = lineBreakMode
        tempLabel.font = font
        tempLabel.text = text
        tempLabel.sizeToFit()
        frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: tempLabel.frame.height)
    }
}

//extension UIFont {
//    @available(iOS 13.0, *)
//    convenience init?(
//        style: UIFont.TextStyle,
//        weight: UIFont.Weight = .regular,
//        design: UIFontDescriptor.SystemDesign = .default) {
//
//        guard let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
//            .addingAttributes([UIFontDescriptor.AttributeName.traits: [UIFontDescriptor.TraitKey.weight: weight]])
//            .withDesign(design) else {
//                return nil
//        }
//        self.init(descriptor: descriptor, size: 0)
//    }
//}

extension UILabel {
    //Font : ["FallingSkyOu", "FallingSkyExt", "FallingSkyLight", "FallingSkyBd", "FallingSkyBlk", "FallingSkySeBd", "FallingSky"]
    
    //Font : ["Gotham-Light", "Gotham-Bold", "Gotham-Medium", "Gotham-Book", "Gotham-BoldItalic"]

    @objc public var substituteFontName : String {
        get {
            return self.font.fontName;
        }
        set {
            let fontNameToTest = self.font.fontName.lowercased()
            
            var isInVal: Bool = false
            
            var fontName = newValue

            if fontNameToTest.range(of: "poppins") != nil {
                if fontNameToTest.range(of: "regular") != nil {
                    fontName += ""
                    isInVal = true
                } else if fontNameToTest.range(of: "medium") != nil {
                    fontName += ""
                    isInVal = true
                } else if fontNameToTest.range(of: "semi") != nil {
                    fontName += "SeBd"
                    isInVal = true
                } else if fontNameToTest.range(of: "bold") != nil {
                    fontName += "Bd"
                    isInVal = true
                }
            }
            
            if isInVal {
                self.font = UIFont(name: fontName, size: self.font.pointSize)
            } else {
                if fontNameToTest.contains(FT_Regular.lowercased()) {
                    self.font = UIFont(name: self.font?.fontName ?? "", size: self.font?.pointSize ?? 15)
                } else {
//                    self.font = UIFont(name: "TimesNewRomanPSMT", size: 17)
                }
            }
        }
    }
}

extension UITextView {
    //Font : ["FallingSkyOu", "FallingSkyExt", "FallingSkyLight", "FallingSkyBd", "FallingSkyBlk", "FallingSkySeBd", "FallingSky"]
    
    @objc public var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? ""
            
            var isInVal: Bool = false
            
            var fontName = newValue

            if fontNameToTest.range(of: "poppins") != nil {
                if fontNameToTest.range(of: "regular") != nil {
                    fontName += ""
                    isInVal = true
                } else if fontNameToTest.range(of: "medium") != nil {
                    fontName += ""
                    isInVal = true
                } else if fontNameToTest.range(of: "semi") != nil {
                    fontName += "SeBd"
                    isInVal = true
                } else if fontNameToTest.range(of: "bold") != nil {
                    fontName += "Bd"
                    isInVal = true
                }
            }
            
            if isInVal {
                self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 15)
            } else {
                if fontNameToTest.contains(FT_Regular.lowercased()) {
                    self.font = UIFont(name: self.font?.fontName ?? "", size: self.font?.pointSize ?? 15)
                } else {
//                    self.font = UIFont(name: FT_Regular, size: 17)
                }
            }
        }
    }
}

extension UITextField {
    //Font : ["FallingSkyOu", "FallingSkyExt", "FallingSkyLight", "FallingSkyBd", "FallingSkyBlk", "FallingSkySeBd", "FallingSky"]
    
    @objc public var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
            let fontNameToTest = self.font?.fontName.lowercased() ?? ""
            
            var isInVal: Bool = false
            
            var fontName = newValue

            if fontNameToTest.range(of: "poppins") != nil {
                if fontNameToTest.range(of: "regular") != nil {
                    fontName += ""
                    isInVal = true
                } else if fontNameToTest.range(of: "medium") != nil {
                    fontName += ""
                    isInVal = true
                } else if fontNameToTest.range(of: "semi") != nil {
                    fontName += "SeBd"
                    isInVal = true
                } else if fontNameToTest.range(of: "bold") != nil {
                    fontName += "Bd"
                    isInVal = true
                }
            }
            
            if isInVal {
                self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 15)
            } else {
                if fontNameToTest.contains(FT_Regular.lowercased()) {
                    self.font = UIFont(name: self.font?.fontName ?? "", size: self.font?.pointSize ?? 15)
                } else {
//                    self.font = UIFont(name: FT_Regular, size: 17)
                }
            }
        }
    }
}

extension UILabel {
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        let readMoreText: String = trailingText + moreText
        
        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font!])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }
    
    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
}

@IBDesignable class GradientLabel: UILabel {
    let gradientLayer = CAGradientLayer()
    @IBInspectable var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: themeBrownColor, bottomGradientColor: themeBrownColor)
        }
    }
    
    @IBInspectable var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: themeBrownColor, bottomGradientColor: themeBrownColor)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        
    }
    
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor {
            gradientLayer.frame = bounds
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = layer.borderColor
            gradientLayer.borderWidth = layer.borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
            layer.insertSublayer(gradientLayer, at: 0)
            
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}

public extension UILabel {
    func addTrailing(image: UIImage?, text:String) {
        let attachment = NSTextAttachment()
        if let image = image{ attachment.image = image }

        let attachmentString = NSAttributedString(attachment: attachment)
        let string = NSMutableAttributedString(string: text, attributes: [:])

        string.append(attachmentString)
        self.attributedText = string
    }
    
    func addLeading(image: UIImage?, text:String) {
        let attachment = NSTextAttachment()
        if let image = image{ attachment.image = image }

        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)
        
        let string = NSMutableAttributedString(string: text, attributes: [:])
        mutableAttributedString.append(string)
        self.attributedText = mutableAttributedString
    }
}
