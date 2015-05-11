//
//  ChartPageControl.swift
//  Pager
//
//  Created by aleksey on 11.05.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import UIKit

class ChartPageControl: UIView {
    private var buttons: [UIView] = []
    
    var pagesCount: Int = 0 {
        didSet {
            layoutButtons()
        }
    }
    
    func selectButton(index:Int) {
        if index > (buttons.count - 1) {
            return
        }
        
        for button in buttons {
            button.backgroundColor = UIColor.blackColor()
        }
        buttons[index].backgroundColor = UIColor.whiteColor()
    }
    
    private func layoutButtons () {
        for button in buttons {
            button.removeFromSuperview()
        }
        
        buttons.removeAll(keepCapacity: false)
        
        if pagesCount == 0 {
            return
        }
        
        let buttonWidth: CGFloat = 10.0
        let gapWidth: CGFloat = 5.0
        let count: CGFloat = CGFloat(pagesCount)
        let totalWidth: CGFloat = buttonWidth * count + gapWidth * (count - 1.0)
        var startX: CGFloat = (frame.size.width - totalWidth) / 2.0
        
        for i in 0..<pagesCount {
            let button = UIView(frame: CGRect(x: startX, y: 0, width: buttonWidth, height: buttonWidth))
            button.backgroundColor = UIColor.blackColor()
            button.layer.cornerRadius = buttonWidth / 2.0
            button.layer.masksToBounds = true
            self.addSubview(button)
            buttons.append(button)
            
            startX += (buttonWidth + gapWidth)
        }
    }
}