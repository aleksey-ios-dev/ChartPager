//
//  ChartPageViewcontroller.swift
//  Pager
//
//  Created by aleksey on 08.05.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import UIKit

protocol ChartPagingViewControllerDataSource {
    func numberOfPages () -> Int
    func colorForPage(index: Int) -> UIColor
    func percentageForPage(index: Int) -> Int
    func titleForPage(index: Int) -> String
    func descriptionForPage(index: Int) -> String
    func shapeForPage(index: Int) -> UIBezierPath
}

class ChartPagingViewController : UIViewController {
    var chartDataSource: ChartPagingViewControllerDataSource?
    @IBOutlet weak var pageViewContainer: UIView!
    @IBOutlet weak var pageControl: ChartPageControl!
    
    private var pageViewController: UIPageViewController = {
        let controller = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options:nil)
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController.view.backgroundColor = UIColor.clearColor()
        pageViewContainer.tlk_addSubview(pageViewController.view, options: TLKAppearanceOptions.Overlay)
        if let number = chartDataSource?.numberOfPages() {
            pageControl.pagesCount = number
            pageControl.selectButton(0)
        }
        
        pageViewController.ac_setDidFinishTransition({ (controller, idx) -> Void in
            self.pageControl.selectButton(Int(idx))
        })
//        pageControl.pagesCount = cdataSource.numberOfPages()

    }
    
    func reloadData() {
        var pages: [UIViewController] = Array()
        
        if let dataSource = chartDataSource {
            for idx in 0..<dataSource.numberOfPages() {
                let vc = ChartSlideViewController(nibName:"ChartSlideViewController", bundle: nil)
                let ame = vc.view.frame
                vc.chartTitle = dataSource.titleForPage(idx)
                vc.chartColor = dataSource.colorForPage(idx)
                vc.chartDescription = dataSource.descriptionForPage(idx)
                vc.percentage = dataSource.percentageForPage(idx)
                pages.append(vc)
            }
            
            if (self.pageControl != nil) {
                pageControl.selectButton(0)
            }
            pageViewController.ac_setViewControllers(pages)
        }
    }
    
    //required staff
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
   required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}