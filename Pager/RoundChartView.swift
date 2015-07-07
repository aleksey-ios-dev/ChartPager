//
//  RoundChartView.swift
//  Pager
//
//  Created by aleksey on 07.07.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import Foundation

class RoundChartView : UIView {
    private var percentage: Int = 0
    
    private let greyChart: CAShapeLayer = {
        let circle: CAShapeLayer = CAShapeLayer()
        circle.position = CGPointZero
        circle.lineCap = kCALineCapRound
        circle.fillColor = UIColor.clearColor().CGColor
        circle.strokeColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        circle.lineWidth = 16.0;
        circle.strokeEnd = 0.0
        return circle
        }()
    
    private let colorChart: CAShapeLayer = {
        let circle: CAShapeLayer = CAShapeLayer()
        circle.position = CGPointZero
        circle.lineCap = kCALineCapRound
        circle.fillColor = UIColor.clearColor().CGColor
        circle.lineWidth = 16.0;
        circle.strokeEnd = 0.0
        circle.strokeColor = UIColor.redColor().CGColor
        return circle
        }()
    
    var chartColor: CGColor {
        set {
            colorChart.strokeColor = newValue
        } get {
            return colorChart.strokeColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.addSublayer(greyChart)
        self.layer.addSublayer(colorChart)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let path: CGPath = UIBezierPath(roundedRect: bounds, cornerRadius: frame.size.width / 2.0).CGPath
        colorChart.path = path
        greyChart.path = path
    }
    
    func show(percentage: Int) {
        self.percentage = percentage
        self.colorChart.addAnimation(animation(percentage, duration: 1.0, timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)), forKey: "show")
        self.greyChart.addAnimation(animation(100, duration: 1.0, timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)), forKey: "show")
    }
    
    func hide() {
        let splashDuration: NSTimeInterval = 0.2
        let toValue: Int = min(100, percentage + 10)
        let splash: CABasicAnimation = animation(toValue, duration: splashDuration, timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        let hide: CABasicAnimation = animation(0, duration: 0.5, timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        hide.beginTime = splashDuration
        let group: CAAnimationGroup = CAAnimationGroup()
        group.duration = 3.0
        group.animations = [splash, hide]
        group.fillMode = kCAFillModeForwards
        group.removedOnCompletion = false
        
        colorChart.addAnimation(group, forKey: "hide")
        
        let greyChartHide = animation(0, duration: 0.5, timingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut));
        greyChartHide.beginTime = CACurrentMediaTime() + splashDuration
        greyChart.addAnimation(greyChartHide, forKey: "hide")
    }
    
    func reset () {
        colorChart.removeAllAnimations()
        greyChart.removeAllAnimations()
    }

    func animation(percentage: Int, duration: NSTimeInterval, timingFunction:CAMediaTimingFunction) -> CABasicAnimation {
        let maxValue: Float = Float(percentage) / 100.0
        let animation: CABasicAnimation = CABasicAnimation(keyPath:"strokeEnd")
        animation.duration = duration
        animation.repeatCount = 1.0
        animation.toValue = maxValue
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        animation.timingFunction = timingFunction
        
        return animation
    }
}
