//
//  TabControllerLayout.swift
//  PocTabViewController
//
//  Created by Felipe Kimio on 11/1/18.
//  Copyright © 2018 Felipe Kimio. All rights reserved.
//

import Foundation
import UIKit

class TabControllerLayout: TabViewControllerFlowLayout {
    
    override init() {
        super.init()
        backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        transitionStyle = .scroll
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
