//
//  TabHeaderLayout.swift
//  PocTabViewController
//
//  Created by Felipe Kimio on 9/6/18.
//  Copyright © 2018 Felipe Kimio. All rights reserved.
//

import Foundation
import UIKit

class TabHeaderLayout: TabHeaderFlowLayout {
    
    override init() {
        super.init()
        headerReferenceSize.height = 100
        sectionHeadersPinToVisibleBounds = true
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
