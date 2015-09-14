//
//  Tween.swift
//  Pager
//
//  Created by aleksey on 13.07.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import Foundation

class Tween : CALayer {
    dynamic var animatable: CGFloat = 2
    var object: AnyObject
    var key: String
    var from: CGFloat
    var to: CGFloat
    var delay: NSTimeInterval = 0.0
    var tweenDuration: NSTimeInterval
    var timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    var mapper: ((value: CGFloat) -> (AnyObject))?

    init (object: AnyObject, key: String, from: CGFloat, to: CGFloat, duration: NSTimeInterval) {
        self.object = object
        self.from = from
        self.to = to
        self.tweenDuration = duration
        self.key = key

        super.init()
    }

//    override init(layer: AnyObject!) {
//        let tweenLayer = layer as! Tween
//        object = tweenLayer.object
//        key = tweenLayer.key
//        from = tweenLayer.from
//        to = tweenLayer.to
//        tweenDuration = tweenLayer.duration
//        super.init(layer: layer)
//    }

    convenience init (object: AnyObject, key: String, to: CGFloat) {
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
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = 4 as NSNumber
//        animation.toValue = to
        animation.duration = tweenDuration
//        animation.beginTime = CACurrentMediaTime() + delay
//        animation.delegate = self

        return animation;
    }

//    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
//        self.removeFromSuperlayer()
//    }

    override func display() {
        print("DISPLAY")
//        let value = presentationLayer()?.animatable

//    if self.presentationLayer() != nil {
//
    }
//            if let mapper = mapper {
//                object.setValue(mapper(value: presentationLayer().animatable), forKey: key)
//            } else {
//                object.setValue(presentationLayer.animatable, forKey: key)
//            }
//        }
//    }

    func start () {
        animatable = to
        (object as! UIView).layer.addSublayer(self)
//        UIApplication.sharedApplication().delegate?.window??.rootViewController?.view.layer.addSublayer(self)
    }

    func start(delay: NSTimeInterval) {
        self.delay = delay
        start()
    }
}