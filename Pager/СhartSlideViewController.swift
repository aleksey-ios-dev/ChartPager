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
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var percentageLabel: UILabel!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var chartContainer: RoundChartView!
    @IBOutlet private weak var ballContainer: UIView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var imageSizeConstraint: NSLayoutConstraint!
    @IBOutlet private weak var descriptionCenterConstraint: NSLayoutConstraint!
    
    var drop: CAShapeLayer?
    
    var graphWidth: CGFloat = 14.0
    
    var chartColor: UIColor? { get {
            return percentageLabel.textColor
        }
        set {
            percentageLabel.textColor = newValue
            logoImageView.tintColor = newValue
            chartContainer.chartColor = newValue!.CGColor
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
            return descriptionLabel.text
        }
        set {
            descriptionLabel.text = newValue
        }
    }
    
    var logoImage: UIImage? {
        get {
         return logoImageView.image
        }
        set {
            logoImageView.image = newValue?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }
    }
    
    var percentage: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = graphWidth
        self.view.layer.masksToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
         super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        chartContainer.reset()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        chartContainer.reset()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        chartContainer.reset()
        
        self.descriptionLabel.hidden = true
        self.percentageLabel.text = ""
        self.imageSizeConstraint.constant = 0.0

        
//        drop?.removeFromSuperlayer()
//        drop = nil
    }
    
    func animate () {
        chartContainer.show(percentage!)
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
           self.chartContainer.hide()
        }
//                        animateGreyCircle(0.9)
//        animateColoredCircle(0.9)
//        animatePercentageLabel(0.9)
//        animateDrop()
//        animateDescription(3.0)
//        animateImage(1.0)
    }
    
    func animateImage(delay: Double) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.imageSizeConstraint.constant = 50.0
                self.view.layoutIfNeeded()
            })
            
            let dropDisappear: CABasicAnimation = CABasicAnimation(keyPath:"transform.scale")
//                            dropDisappear.beginTime = dropLay.beginTime - 0.1
            dropDisappear.duration = 0.3
                            dropDisappear.repeatCount = 1.0
                            dropDisappear.fromValue = 1.0
            dropDisappear.toValue = NSValue(CATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0))
                            dropDisappear.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
                            dropDisappear.autoreverses = false
            dropDisappear.removedOnCompletion = false
            dropDisappear.fillMode = kCAFillModeForwards

            self.drop!.addAnimation(dropDisappear, forKey: "disappear")
        }
    }
    
    func animateDescription (delay: Double) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        
        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            self.descriptionLabel.hidden = false
            self.descriptionLabel.chr_animateAlpha(0.5, delay:0.0)
            
            self.descriptionCenterConstraint.constant = -50.0
            self.view.layoutIfNeeded()
            UIView.animateWithDuration(0.7, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.descriptionCenterConstraint.constant = 0.0
                self.view.layoutIfNeeded()
                }, completion: nil)
        }
    }
    
    func animateDrop () {
         drop = CAShapeLayer()

        drop!.path = UIBezierPath(ovalInRect: CGRect(
            x: 0.0,
            y: (-graphWidth / 2.0),
            width: graphWidth,
            height: graphWidth)).CGPath
        drop!.fillColor = chartColor!.CGColor
        ballContainer.layer.addSublayer(drop)
        
        let dropFall: CABasicAnimation = CABasicAnimation(keyPath:"transform.translation.y")
        dropFall.duration = 0.3
        dropFall.repeatCount = 1.0
        dropFall.fromValue = 0.0
        dropFall.toValue = self.chartContainer.frame.size.height - graphWidth
        dropFall.timingFunction = fallEaseIn()
        
        let dropLay: CABasicAnimation = CABasicAnimation(keyPath:"transform.translation.y")
        dropLay.beginTime = dropFall.duration
        dropLay.duration = 0.05
        dropLay.repeatCount = 1.0
        dropLay.fromValue = dropFall.toValue
        dropLay.toValue = dropFall.toValue
        dropLay.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        
        let dropJump: CABasicAnimation = CABasicAnimation(keyPath:"transform.translation.y")
        dropJump.beginTime = dropFall.duration + dropLay.duration
        dropJump.duration = dropFall.duration * 1.5
        dropJump.repeatCount = 1.0
        dropJump.fromValue = dropFall.toValue
        dropJump.toValue = 0.0
        dropJump.timingFunction = fallEaseOut()
        
        let dropSmash: CABasicAnimation = CABasicAnimation(keyPath:"transform.scale.y")
        dropSmash.beginTime = dropLay.beginTime - 0.1
        dropSmash.duration = dropLay.duration
        dropSmash.repeatCount = 1.0
        dropSmash.fromValue = 1.0
        dropSmash.toValue = 0.6
        dropSmash.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
        dropSmash.autoreverses = true
        dropSmash.removedOnCompletion = false
        
        let group: CAAnimationGroup = CAAnimationGroup()
        group.duration = 7.0
        group.animations = [dropFall, dropLay, dropJump, dropSmash]
        group.removedOnCompletion = true

        drop!.addAnimation(group, forKey: "move")
    }
    
    //Chart setup
//    
//    func animateColoredCircle(delay: Double) {
//
//        //Add main chart
//        let radius: CGFloat = self.chartContainer.frame.size.width / 2.0
//        let circle: CAShapeLayer = CAShapeLayer()
//        
//        circle.position = CGPointZero
//        circle.lineCap = kCALineCapRound
//        circle.path = UIBezierPath(roundedRect: chartContainer.bounds, cornerRadius: radius).CGPath
//
//        circle.fillColor = UIColor.clearColor().CGColor
//        circle.strokeColor = chartColor!.CGColor //TODO: нужен дефолтный цвет, если нет нормального
//        circle.lineWidth = graphWidth;
//        circle.strokeEnd = 0.0
//        
//
//        chartContainer.layer.addSublayer(circle)
//        
//        //Animate colored circle
//        
//        let maxValue: Float = Float(percentage!) / 100.0
//        
//        let mainChartShow: CABasicAnimation = CABasicAnimation(keyPath:"strokeEnd")
//        mainChartShow.beginTime = delay
//        mainChartShow.duration = 1.0;
//        mainChartShow.repeatCount = 1.0;
//        mainChartShow.fromValue = 0.0
//        mainChartShow.toValue = maxValue
////        mainChartShow.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
//        mainChartShow.timingFunction = easeOut()
//        
//        let mainChartStable: CABasicAnimation = CABasicAnimation(keyPath:"strokeEnd")
//        mainChartStable.duration = 1.2;
//        mainChartStable.beginTime = mainChartShow.beginTime + mainChartShow.duration
//        mainChartStable.repeatCount = 1.0;
//        mainChartStable.fromValue = maxValue
//        mainChartStable.toValue = maxValue
//        
//        let mainChartHide: CABasicAnimation = CABasicAnimation(keyPath:"strokeEnd")
//        mainChartHide.beginTime = mainChartStable.beginTime + mainChartStable.duration
//        mainChartHide.duration = 0.4;
//        mainChartHide.repeatCount = 1.0;
//        mainChartHide.fromValue = maxValue
//        mainChartHide.toValue = 0.0
//        mainChartHide.timingFunction = easeOut()
//        mainChartHide.removedOnCompletion = false
//        
//        let group: CAAnimationGroup = CAAnimationGroup()
//        group.duration = 7.0
//        group.animations = [mainChartShow, mainChartStable, mainChartHide]
//        group.removedOnCompletion = false
//        
//        circle.addAnimation(group, forKey: "drawOutlineAnimation")
//    }
    
//    func animateGreyCircle(delay: Double) {
//        let radius: CGFloat = self.chartContainer.frame.size.width / 2.0
//        let circle: CAShapeLayer = CAShapeLayer()
//        
//        circle.position = CGPointZero
//        circle.lineCap = kCALineCapRound
//        circle.path = UIBezierPath(roundedRect: chartContainer.bounds, cornerRadius: radius).CGPath
//        
//        circle.fillColor = UIColor.clearColor().CGColor
//        circle.strokeColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
//        circle.lineWidth = graphWidth;
//        circle.strokeEnd = 0.0
//        
//        chartContainer.layer.addSublayer(circle)
//        
//        let maxValue: Float =  1.0
//        
//        let mainChartShow: CABasicAnimation = CABasicAnimation(keyPath:"strokeEnd")
//        mainChartShow.beginTime = delay
//        mainChartShow.duration = 1.0;
//        mainChartShow.repeatCount = 1.0;
//        mainChartShow.fromValue = 0.0
//        mainChartShow.toValue = maxValue
//        mainChartShow.timingFunction = easeOut()
//        
//        
//        let mainChartStable: CABasicAnimation = CABasicAnimation(keyPath:"strokeEnd")
//        mainChartStable.duration = 1.2;
//        mainChartStable.beginTime = mainChartShow.beginTime + mainChartShow.duration
//        mainChartStable.repeatCount = 1.0;
//        mainChartStable.fromValue = maxValue
//        mainChartStable.toValue = maxValue
//        
//        let mainChartHide: CABasicAnimation = CABasicAnimation(keyPath:"strokeEnd")
//        mainChartHide.beginTime = mainChartStable.beginTime + mainChartStable.duration
//        mainChartHide.duration = 0.4
//        mainChartHide.repeatCount = 1.0
//        mainChartHide.fromValue = maxValue
//        mainChartHide.toValue = 0.0
//        mainChartHide.timingFunction = easeOut()
//        mainChartHide.removedOnCompletion = false
//        
//        let group: CAAnimationGroup = CAAnimationGroup()
//        group.duration = 7.0
//        group.animations = [mainChartShow, mainChartStable, mainChartHide]
//        group.removedOnCompletion = false
//        
//        circle.addAnimation(group, forKey: "drawOutlineAnimation")
//    }
    
    //Animate Percentage Label`
    
    func animatePercentageLabel (delay: Double) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        

        let tween: Tween = Tween(from: 0.0, to: Double(self.percentage!), duration: 1.0)
        tween.stepCallback = {(value) -> Void in
            self.percentageLabel.text = "\(Int(value))"
        }

        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
            tween.perform()
        }
    }
    
    func easeOut () -> CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.4, 1.0)
    }
    
    
    func fallEaseIn () -> CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.4, 0.0, 1.0, 0.4)
    }
    
    
    func fallEaseOut () -> CAMediaTimingFunction {
        return CAMediaTimingFunction(controlPoints: 0.0, 0.4, 0.4, 1.0)
    }
    
    
}




