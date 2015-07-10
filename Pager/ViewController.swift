//
//  ViewController.swift
//  Pager
//
//  Created by aleksey on 08.05.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ChartPagingViewControllerDataSource {

    var pageViewController: ChartPagingViewController = ChartPagingViewController(nibName: "ChartPagingViewController", bundle: nil)
    
    let objects: [ChartObject] = {
        var objects: [ChartObject] = []
        
        let filePath = NSBundle.mainBundle().pathForResource("Objects", ofType: "plist")
        let contents = NSArray(contentsOfFile: filePath!)! as Array
        
        for dictionary in contents {
            let object = ChartObject()
            if let title: String = dictionary["title"] as? String {
                object.title = title
            }
            
            if let description: String = dictionary["description"] as? String {
                object.description = description
            }
            if let colorString: String = dictionary["color"] as? String {
                object.color = UIColor(hexString: colorString)
            }
            
            if let percentage: Int = dictionary["percentage"] as? Int {
                object.percentage = percentage
            }
            
            if let logoName: String = dictionary["logoName"] as? String {
                object.logoImage = UIImage(named: logoName)
            }
            
            objects.append(object)
        }
        
        return objects
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController.chartDataSource = self
        pageViewController.reloadData()
        pageViewController.view.frame = self.view.frame
        self.addChildViewController(pageViewController)
        self.view.tlk_addSubview(pageViewController.view, options: TLKAppearanceOptions.Overlay)
    }
    
    // Paging Data Source
    
    func numberOfPages() -> (Int) {
        return objects.count
    }
    
    func colorForPage(index: Int) -> UIColor {
        return objects[index].color!
    }
    
    func percentageForPage(index: Int) -> Int {
        return objects[index].percentage!
    }
    
    func titleForPage(index: Int) -> String {
        return objects[index].title!
    }
    
    func descriptionForPage(index: Int) -> String {
        return objects[index].description!
    }
    
    func logoForPage(index: Int) -> UIImage {
        return objects[index].logoImage!
    }
    
    func chartThickness() -> CGFloat {
        return 15.0
    }
}
