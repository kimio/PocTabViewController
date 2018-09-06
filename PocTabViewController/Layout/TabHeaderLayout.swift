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
        headerReferenceSize.height = 40
        sectionHeadersPinToVisibleBounds = true
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        transitionStyle = .scroll
        backgroundHeaderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        backgroundColorViewController = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func itemSize(frame: CGRect) {
        itemSize = CGSize(width: frame.width, height: headerReferenceSize.height)
    }
}
