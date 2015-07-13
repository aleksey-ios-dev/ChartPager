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

///согласно пока неутвержденному кодестайлу рекомендуется оборачивать каждую реализацию интерфейса в екстеншен в том же файле
///это дает прозрачность и структурированность кода
///extension ChartPagingViewController: ChartPageControlDelegate
class ChartPagingViewController : UIViewController, ChartPageControlDelegate {
    ///не уверен что без дата сорса контроллер имеет смысл, может лучше var chartDataSource: ChartPagingViewControllerDataSource!
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
        
        pageControl.delegate = self
    }
    
    func reloadData() {
        pageViewController.ac_setDidFinishTransition({ (pageController, viewController, idx) -> Void in
            ///PageControl вроде как всегда существует зачем chaining?
            self.pageControl?.selectButton(Int(idx))
            let slide = viewController as! ChartSlideViewController
            slide.animate()
        })
        ///короче var pages = [UIViewController]()
        var pages: [UIViewController] = Array()
        
        if let dataSource = chartDataSource {
            for idx in 0..<dataSource.numberOfPages() {
                let vc = ChartSlideViewController(nibName:"ChartSlideViewController", bundle: nil)
                let ame = vc.view.frame
                vc.chartTitle = dataSource.titleForPage(idx)
                vc.chartColor = dataSource.colorForPage(idx)
                vc.chartDescription = dataSource.descriptionForPage(idx)
                vc.percentage = dataSource.percentageForPage(idx)
                vc.logoImage = dataSource.logoForPage(idx)
                vc.chartThickness = dataSource.chartThickness()
                pages.append(vc)
            }
            
            ///чо ж такое с этим контролом - аутлет же вроде куда ему дется
            if (self.pageControl != nil) {
                ///тоже название параметра не помешает
                pageControl.selectButton(0)
            }
            pageViewController.ac_setViewControllers(pages)
        }
    }
    
    //ChartPageControlDelegate
    
    func pageControlDidSelectButton(index: Int) {
        pageViewController.ac_showPage(index)
    }
}