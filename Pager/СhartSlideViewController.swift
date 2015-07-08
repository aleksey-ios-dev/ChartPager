//
//  СhartViewController.swift
//  Pager
//
//  Created by aleksey on 08.05.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import UIKit

class ChartSlideViewController : UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionView: SlideLabelView!
    @IBOutlet private weak var percentageLabel: UILabel!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var chartView: RoundChartView!
    @IBOutlet private weak var dropView: DropView!
    @IBOutlet private weak var descriptionCenterConstraint: NSLayoutConstraint!
    
    private var animationPlayed = false
    
    var graphWidth: CGFloat = 18.0
    
    var chartColor: UIColor? { get {
            return percentageLabel.textColor
        }
        set {
            percentageLabel.textColor = newValue
            chartView.chartColor = newValue!
            dropView.color = newValue!
        }
    }
    
    var chartTitle: String? {
        get {
            return titleLabel.text
        }
        set {
            if let value = newValue {
                titleLabel.text = newValue
            }
        }
    }
    
    var chartDescription: String? {
        get {
            return descriptionView.text
        }
        set {
            descriptionView.text = newValue
        }
    }
    
    var logoImage: UIImage? {
        get {
         return dropView.logo
        }
        set {
            dropView.logo = newValue!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }
    }
    
    var percentage: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = graphWidth
        self.view.layer.masksToBounds = true
    }
    
    func animate () {
        if animationPlayed {return}
        animationPlayed = true
        
        dropView.animateDrop()
        chartView.show(percentage!, delay: 0.9)
        animatePercentageLabel(0.9)
        descriptionView.animate(3.7)
        dropView.animateLogo(4.2)
    }
    
    func animatePercentageLabel (delay: Double) {
        let tween: Tween = Tween(from: 0.0, to: Double(self.percentage!), duration: 1.0)
        tween.stepCallback = {(value) -> Void in
            self.percentageLabel.text = "\(Int(value))"
        }
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))

        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            tween.perform()
        }
    }
}




