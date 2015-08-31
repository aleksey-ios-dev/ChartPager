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
    func logoForPage(index: Int) -> UIImage
    func chartThickness () -> CGFloat
}

class ChartPagingViewController : UIViewController {
    var chartDataSource: ChartPagingViewControllerDataSource!

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
        pageControl.pagesCount = chartDataSource.numberOfPages()
        pageControl.selectButton(0)
        reloadData()
    }
    
    func reloadData() {
        pageViewController.ac_setDidFinishTransition({ (pageController, viewController, idx) -> Void in
            self.pageControl.selectButton(Int(idx))
            let slide = viewController as! ChartSlideViewController
            slide.animate()
        })
        
        var pages: [UIViewController] = Array()
        
        for idx in 0..<chartDataSource.numberOfPages() {
            let vc = ChartSlideViewController(nibName:"ChartSlideViewController", bundle: nil)
            let ame = vc.view.frame
            vc.chartTitle = chartDataSource.titleForPage(idx)
            vc.chartColor = chartDataSource.colorForPage(idx)
            vc.chartDescription = chartDataSource.descriptionForPage(idx)
            vc.percentage = chartDataSource.percentageForPage(idx)
            vc.logoImage = chartDataSource.logoForPage(idx)
            vc.chartThickness = chartDataSource.chartThickness()
            pages.append(vc)

            pageControl.selectButton(0)
            pageViewController.ac_setViewControllers(pages)
        }
    }
}