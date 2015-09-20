//
// Created by aleksey on 14.09.15.
// Copyright (c) 2015 aleksey chernish. All rights reserved.
//

import Foundation

class Tween {
    private weak var layer: TweenLayer!

    let object: UIView
    let key: String

    var timingFunction: CAMediaTimingFunction {
        set {
            layer.timingFunction = newValue
        }
        get {
            return layer.timingFunction
        }
    }

    var mapper: ((value: CGFloat) -> (AnyObject))?

    init (object: UIView, key: String, from: CGFloat, to: CGFloat, duration: NSTimeInterval) {
        self.object = object
        self.key = key

        layer = {
            let layer = TweenLayer()
            object.layer.addSublayer(layer)
            layer.from = from
            layer.to = to
            layer.tweenDuration = duration
            layer.animationDelegate = self

            return layer
        }()
    }

    convenience init (object: UIView, key: String, to: CGFloat) {
        self.init(object: object, key: key, from: 0, to: to, duration: 0.5)
    }

    func start() {
        layer.startAnimation()
    }

    func start(delay delay: NSTimeInterval) {
        self.layer.delay = delay
        start()
    }
}

extension Tween: TweenLayerDelegate {
    func tweenLayer(layer: TweenLayer, didSetAnimatableProperty to: CGFloat) {
        if let mapper = mapper {
            object.setValue(mapper(value: to), forKey: key)
        } else {
            object.setValue(to, forKey: key)
        }
    }

    func tweenLayerDidStopAnimation(layer: TweenLayer) {
        layer.removeFromSuperlayer()
    }
}


