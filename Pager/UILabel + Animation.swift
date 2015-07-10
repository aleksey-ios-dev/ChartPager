//
//  UILabel + Animation.swift
//  Pager
//
//  Created by aleksey on 08.06.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import Foundation

extension UILabel {
    func chr_animateAdding (duration: Double) {
        if let text = self.text {
            chr_iterateAdding(text, index: 0, delay: duration / Double(count(text)))
        }
    }
    
    private func chr_iterateAdding (text: NSString, index: Int, delay: Double) {
        let substring = text.substringToIndex(index)
        self.text = substring
        
        if (text != substring) {
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            
            dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
                self.chr_iterateAdding(text, index: index + 1, delay: delay)
            }
        }
    }
    
    func chr_animateAlpha (duration: Double, delay: Double) {
        if let text = self.text {
            
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            
            let originalFontColor = self.textColor
            
            textColor = UIColor.clearColor()
            dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
                self.chr_iterateAlpha(text, index: 0, delay: duration / Double(count(text)), font: self.font, color: originalFontColor)
            }
        }
    }
    
    private func chr_iterateAlpha (text: NSString, index: Int, delay: Double, font: UIFont, color: UIColor) {
            let substringToShow = text.substringToIndex(index);
            let substringToHide = text.substringFromIndex(index);
            
                let showAttrs = [NSFontAttributeName :font,
                    NSForegroundColorAttributeName: color]
                let showString = NSAttributedString(string: substringToShow, attributes:showAttrs)
                
                let hideAttrs = [NSFontAttributeName: font,
                    NSForegroundColorAttributeName : UIColor.clearColor()]
                
                let hideString = NSAttributedString(string: substringToHide, attributes: hideAttrs)
                
                var result: NSMutableAttributedString = NSMutableAttributedString()
                result.appendAttributedString(showString)
                result.appendAttributedString(hideString)
                
                self.attributedText = result
            
            if (count(substringToHide) != 0) {
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))

                dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
                    self.chr_iterateAlpha(text, index: index + 1, delay: delay, font: font, color:color)
                }
            }
    }
}