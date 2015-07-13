//
//  ChartPageControl.swift
//  Pager
//
//  Created by aleksey on 11.05.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import UIKit

///для протокола тоже желательно оставлять пустую строку снизу и сверху
protocol ChartPageControlDelegate {
    /// пробел обязателен после названия аргумента
    func pageControlDidSelectButton(index:Int)
}

class ChartPageControl: UIView {
    /// два пробела после var
    ///странный делегат который нигде не используется и судя по-всему он должен быть объявлен как Implicitly Unwrapped Optional = var delegate: ChartPageControlDelegate!
    var  delegate: ChartPageControlDelegate?
    /// рекомендована сокращенная запись private var buttons = [UIView]()
    ///можно даже было не создавать массив, а только объявить переменную private var buttons: [UIView]?
    /// и иницилизировать массив только если pageCount > 0
    private var buttons: [UIView] = []
    
    ///избыточное указание типа
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
            ///можно сделать экстеншен на UIColor чтобы не писать постоянно / 255
            /// .0 излишняя запись - Swift всегда делит правильно
            button.backgroundColor = UIColor(red: 185 / 255, green: 185 / 255.0, blue: 185 / 255.0, alpha: 1.0)

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
            self.addSubview(button)
            buttons.append(button)
            
            startX += (buttonWidth + gapWidth)
        }
    }
}