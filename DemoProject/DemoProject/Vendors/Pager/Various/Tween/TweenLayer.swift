//
// Created by aleksey on 14.09.15.
// Copyright (c) 2015 aleksey chernish. All rights reserved.
//

import Foundation

protocol TweenLayerDelegate: class {
    func tweenLayer(layer: TweenLayer, didSetAnimatableProperty to: CGFloat) -> Void
    func tweenLayerDidStopAnimation(layer: TweenLayer) -> Void
}

class TweenLayer: CALayer {
    @NSManaged private var animatable: CGFloat

    var tween: TweenLayerDelegate?

    var from: CGFloat = 0
    var to: CGFloat = 0
    var tweenDuration: NSTimeInterval = 0.5
    var timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    var delay: NSTimeInterval = 0

    override class func needsDisplayForKey(event: String) -> Bool {
        return event == "animatable" ? true : super.needsDisplayForKey(event)
    }

    override func actionForKey(event: String!) -> CAAction! {
        if event != "animatable" {
            return super.actionForKey(event)
        }
        let animation = CABasicAnimation(keyPath: event)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = tweenDuration
        animation.beginTime = CACurrentMediaTime() + delay
        animation.delegate = self

        return animation;
    }

    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        tween?.tweenLayerDidStopAnimation(self)
    }

    override func display() {
        if let value = presentationLayer()?.animatable {
            tween?.tweenLayer(self, didSetAnimatableProperty: value)
        }
    }

    func startAnimation() {
        animatable = to
    }
}
