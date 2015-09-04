//
//  Tween.swift
//  Pager
//
//  Created by aleksey on 13.07.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import Foundation

class Tween : CALayer {
    var object: NSObject
    var key: String
    var from: CGFloat
    var to: CGFloat
    var tweenDuration: NSTimeInterval
    var timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    var delay: NSTimeInterval = 0.0
    @NSManaged var animatable: CGFloat
    var mapper: ((value: CGFloat) -> (AnyObject))?
    
    init (object: NSObject, key: String, from: CGFloat, to: CGFloat, duration: NSTimeInterval) {
        self.object = object
        self.from = from
        self.to = to
        self.tweenDuration = duration
        self.key = key
        
        super.init()
    }
    
    override init(layer: AnyObject!) {
        let tweenLayer = layer as! Tween
        object = tweenLayer.object
        key = tweenLayer.key
        from = tweenLayer.from
        to = tweenLayer.to
        tweenDuration = tweenLayer.duration
        super.init(layer: layer)
    }
    
    convenience init (object: NSObject, key: String, to: CGFloat) {
        self.init(object: object, key: key, from: 0.0, to: to, duration: 0.5)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func needsDisplayForKey(event: String) -> Bool {
        return event == "animatable" ? true : super.needsDisplayForKey(event)
    }
    
    override func actionForKey(event: String!) -> CAAction! {
        if event != "animatable" {
            return super.actionForKey(event)
        } 
        let animation = CABasicAnimation(keyPath: event)
        animation.timingFunction = timingFunction
        animation.fromValue = from
        animation.toValue = to
        animation.duration = tweenDuration
        animation.beginTime = CACurrentMediaTime() + delay
        animation.delegate = self
        
        return animation;
    }
    
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        self.removeFromSuperlayer()
    }
    
    override func display() {
        if let value = presentationLayer()?.animatable {
            if let mapper = self.mapper {
                object.setValue(mapper(value: value), forKey: key)
            } else {
                object.setValue(value, forKey: key)
            }
        }
    }
    
    func start () {
        animatable = to
        UIApplication.sharedApplication().delegate?.window??.rootViewController?.view.layer.addSublayer(self)
    }
    
    func start(delay: NSTimeInterval) {
        self.delay = delay
        start()
    }
}