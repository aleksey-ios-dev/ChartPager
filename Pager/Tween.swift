//
//  Tween.swift
//  Pager
//
//  Created by aleksey on 24.05.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//


class Tween {
    var duration: Double
    var from: Double
    var to: Double
    var steps = 100
    
    var stepCallback: ((value: Double) -> ())?
    
    init(from: Double, to: Double, duration: Double) {
        self.from = from
        self.to = to
        self.duration = duration
    }
    
    func perform () {
        var intermediateValues: [Double] = []
        let step: Double = Double(to - from) / Double(steps)
        let stepDuration = duration / Double(steps)
        
        for i in 0...steps {
            let part: Double = Double(i) / Double(steps)
            let sinPart = sin(M_PI / 2 * part)
            intermediateValues.append(from + (to - from) * sinPart)

        }
        
        iterate(intermediateValues, idx: 0)
    }
    
    func iterate (array:[Double], idx: Int) {
        if (idx >= array.count) {
            return
        }
        if let callback = stepCallback {
            callback(value: array[idx])
        }
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(duration / Double(steps) * Double(NSEC_PER_SEC)))
        
        if (idx < array.count) {
            dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
                self.iterate(array, idx: idx + 1)
            }
        }
    }
}
