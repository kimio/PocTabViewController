//
//  BodyViewController.swift
//  PocTabViewController
//
//  Created by Felipe Kimio on 9/5/18.
//  Copyright © 2018 Felipe Kimio. All rights reserved.
//

import UIKit

class BodyViewController: TabController {
    var label: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label = UILabel(frame: view.frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let views: [String: UIView] = ["v0": label]
        ["H:|-15-[v0]-15-|","V:|[v0]|"].forEach { (visualFormat) in
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                                          options: NSLayoutFormatOptions(),
                                                          metrics: nil,
                                                          views: views))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
