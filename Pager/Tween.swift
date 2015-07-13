//
//  Tween.swift
//  Pager
//
//  Created by aleksey on 24.05.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

///класс вроде как вообще не используется или я чото не понял
/// лучше было бы юзать структуру
class Tween {
    ///модификаторы доступа играют большое значение в Swift - необходимо использовать наиболее скрытую реализацию для обеспечения инкапсуляции
    ///все что возможно должно быть объявлено как константа (swift 1.2 поддерживает константы с отложенной инициализацией)
    var duration: Double // let duration
    var from: Double // let from
    var to: Double // let to
    ///я так понимаю что это константа тогда она должна быть вне тела класса и выглядеть так private let steps = 100
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
        ///это плохой стиль нужно использовать Optional Chaining - callback?(value: array[idx])
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
