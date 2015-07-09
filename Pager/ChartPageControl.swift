//
//  ChartPageControl.swift
//  Pager
//
//  Created by aleksey on 11.05.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import UIKit

protocol ChartPageControlDelegate {
    func pageControlDidSelectButton(index:Int)
}

class ChartPageControl: UIView {
    var  delegate: ChartPageControlDelegate?
    
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
            button.backgroundColor = UIColor(red: 185 / 255.0, green: 185 / 255.0, blue: 185 / 255.0, alpha: 1.0)

        }
        buttons[index].backgroundColor = UIColor(red: 50 / 255.0, green: 50 / 255.0, blue: 50 / 255.0, alpha: 1.0)
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
        let gapWidth: CGFloat = 8.0
        let count: CGFloat = CGFloat(pagesCount)
        let totalWidth: CGFloat = buttonWidth * count + gapWidth * (count - 1.0)
        var startX: CGFloat = (frame.size.width - totalWidth) / 2.0
        
        for i in 0..<pagesCount {
            let button = UIButton(frame: CGRect(x: startX, y: 0, width: buttonWidth, height: buttonWidth))
            button.backgroundColor = UIColor(red: 50 / 255.0, green: 50 / 255.0, blue: 50 / 255.0, alpha: 1.0)
            button.layer.cornerRadius = buttonWidth / 2.0
            button.layer.masksToBounds = true
            button.tag = i
            button.addTarget(self, action: "buttonClick:", forControlEvents: UIControlEvents.TouchUpInside)
            self.addSubview(button)
            buttons.append(button)
            
            startX += (buttonWidth + gapWidth)
        }
    }
    
    func buttonClick(sender:UIButton) {
        delegate?.pageControlDidSelectButton(sender.tag)
        selectButton(sender.tag)
    }
}