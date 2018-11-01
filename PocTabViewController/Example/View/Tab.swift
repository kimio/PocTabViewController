//
//  Tab.swift
//  PocTabViewController
//
//  Created by Felipe Kimio on 9/6/18.
//  Copyright © 2018 Felipe Kimio. All rights reserved.
//

import Foundation
import UIKit

class Tab: UIView {

    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        let views: [String: UIView] = ["v0": label]
        ["H:|-15-[v0]-15-|","V:|[v0]|"].forEach { (visualFormat) in
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                                          options: NSLayoutFormatOptions(),
                                                          metrics: nil,
                                                          views: views))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
