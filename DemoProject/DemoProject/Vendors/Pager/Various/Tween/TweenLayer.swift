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
    @NSManaged private var animatableProperty: CGFloat

    var animationDelegate: TweenLayerDelegate?

    var from: CGFloat = 0
    var to: CGFloat = 0
    var tweenDuration: NSTimeInterval = 0
    var timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    var delay: NSTimeInterval = 0

    override class func needsDisplayForKey(event: String) -> Bool {
        return event == "animatableProperty" ? true : super.needsDisplayForKey(event)
    }

    override func actionForKey(event: String) -> CAAction? {
        if event != "animatableProperty" {
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

    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        animationDelegate?.tweenLayerDidStopAnimation(self)
    }

    override func display() {
        if let value = presentationLayer()?.animatableProperty {
            animationDelegate?.tweenLayer(self, didSetAnimatableProperty: value)
        }
    }

    func startAnimation() {
        animatableProperty = to
    }
}
