//
//  ChartPageViewcontroller.swift
//  Pager
//
//  Created by aleksey on 08.05.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import UIKit

protocol ChartPageViewControllerDataSource {
    func numberOfPages () -> Int
    func colorForPage(index: Int) -> UIColor
    func percentageForPage(index: Int) -> Int
    func titleForPage(index: Int) -> String
    func descriptionForPage(index: Int) -> String
    func shapeForPage(index: Int) -> UIBezierPath
}

class ChartPageViewController : UIPageViewController {
    var chartDataSource: ChartPageViewControllerDataSource?
    
    class func controller() -> ChartPageViewController {
        let controller = ChartPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options:nil)
        
        return controller
    }
    
    func reloadData() {
        var pages: [UIViewController] = Array()
        
        if let dataSource = chartDataSource {
            for idx in 0..<dataSource.numberOfPages() {
                let vc = ChartViewController(nibName:"ChartViewController", bundle: nil)
                let ame = vc.view.frame
                vc.chartTitle = dataSource.titleForPage(idx)
                vc.chartColor = dataSource.colorForPage(idx)
                vc.chartDescription = dataSource.descriptionForPage(idx)
                vc.percentage = dataSource.percentageForPage(idx)
                pages.append(vc)
            }
            
            self.ac_setViewControllers(pages)
        }
    }
}