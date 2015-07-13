//
//  UILabel + Animation.swift
//  Pager
//
//  Created by aleksey on 08.06.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import Foundation
///для названий файлов с екстеншенами не нужно писать + и свое название эекстеншена в любом случае они безымянные
extension UILabel {
    ///согласно моему файлу кодестайла нужно оставлять пустую строку в начале и в конце структуры/класса/екстеншена (можно не следовать так как кодестайл еще не утвержден)
    ///не рекомендуются использовать префиксы в Swift и в частности для методов екстешена
    func chr_animateAdding (duration: Double) {
        ///согласно нашему кодестайлу нужно писать селф только там где его нельзя не писать
        ///т.е if let text = text (выглядит немного непривычно но это рекомендованный стиль)
        if let text = self.text {
            chr_iterateAdding(text, index: 0, delay: duration / Double(count(text)))
        }
    }
    
    ///не рекомендуются использовать Objective-C классы там, где можно обойтись Swift аналогами
    private func chr_iterateAdding (text: NSString, index: Int, delay: Double) {
        let substring = text.substringToIndex(index)
        self.text = substring
        
        ///Скобки вокруг аргумента оператора if не рекомендуются
        if (text != substring) {
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            
            ///хороший стиль сигнатуры замыкания, но если она настолько примитивна, то ее можно опустить,
            ///безболезненно удалив () -> Void in
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
        
        ///нет единого стиля Dictionary, рекомендуется [key: value]
                let showAttrs = [NSFontAttributeName :font,
                    NSForegroundColorAttributeName: color]
                let showString = NSAttributedString(string: substringToShow, attributes:showAttrs)
                
                let hideAttrs = [NSFontAttributeName: font,
                    NSForegroundColorAttributeName : UIColor.clearColor()]
                
                let hideString = NSAttributedString(string: substringToHide, attributes: hideAttrs)
        
        ///излишнее указание типа - Swift использует type inferring "угадывая" тип из контекста
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