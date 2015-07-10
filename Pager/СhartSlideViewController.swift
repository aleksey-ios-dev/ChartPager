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
    
    var chartThickness: CGFloat = 0.0 {
        didSet {
            dropView.chartThickness = chartThickness
            chartView.chartThickness = chartThickness
        }
    }
    
    var chartColor: UIColor? { get {
            return percentageLabel.textColor
        }
        set {
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
        
        self.view.layer.cornerRadius = chartThickness
        self.view.layer.masksToBounds = true
    }
    
    func animate () {
        if animationPlayed {return}
        animationPlayed = true
        
        dropView.animateDrop(0.0)
        chartView.show(percentage!, delay: 0.9)
        animatePercentageLabel(0.9)
        descriptionView.animate(2.7)
        dropView.animateLogo(2.7)
    }
    
    func animatePercentageLabel (delay: Double) {
        let tween: YALTween = YALTween (object: self.percentageLabel, key: "text", range: NSMakeRange(0, percentage!), duration: 0.5)
        
        tween.timingFunction = CAMediaTimingFunction(controlPoints: 0.0, 0.4, 0.4, 1.0)

        tween.mapper = {
            animatable in
            if (animatable == 0) {return ""}
            return String(format: "%0.f%%", animatable)
        }
        
        tween.startWithDelay(delay);
    }
}




