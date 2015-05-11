//
//  СhartViewController.swift
//  Pager
//
//  Created by aleksey on 08.05.15.
//  Copyright (c) 2015 Aleksey Chernish. All rights reserved.
//

import UIKit

class ChartViewController : UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    var chartColor: UIColor? { get {
            return percentageLabel.textColor
        }
        set {
            percentageLabel.textColor = newValue
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
    
    var percentage: Int? {
        get {
            return percentageLabel.text?.toInt()
        }
        set {
            percentageLabel.text = "\(newValue!)"
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
         super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}




