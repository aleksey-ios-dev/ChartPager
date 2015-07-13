//
//  SlideLabel.swift
//  Pager
//
//  Created by aleksey on 08.07.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import Foundation

class SlideLabelView: UIView {
    private var label: UILabel = {
       let label = UILabel()
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.textColor = UIColor(red: 47/255.0, green: 49/255.0, blue: 49/255.0, alpha: 1.0)
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        return label
    }()
    
    ///лучше не писать в одну строку
    var text: String? {
        set {label.text = newValue}
        get {return label.text}
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(label)
        label.hidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
        ///magic numbers
        label.ac_trimLeft(40.0)
        label.ac_trimRight(40.0)
    }
    
    ///было бы неплохо показывать имя аргумента, чтобы понять что ты передаешь - func animate (#delay: NSTimeInterval)
    func animate (delay: NSTimeInterval) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))

        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            self.label.hidden = false
        }

        let labelShift: CABasicAnimation = CABasicAnimation(keyPath:"transform.translation.x")
        labelShift.beginTime = CACurrentMediaTime() + delay
        labelShift.duration = 0.7
        labelShift.fromValue = 50.0
        labelShift.toValue = 0.0
        labelShift.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        label.layer.addAnimation(labelShift, forKey: "shift")
        
        label.chr_animateAlpha(0.5, delay:delay)
    }
}
