//
//  TabFlowLayout.swift
//  PocTabViewController
//
//  Created by Felipe Kimio on 9/3/18.
//  Copyright © 2018 Felipe Kimio. All rights reserved.
//

import Foundation
import UIKit

class TabViewControllerFlowLayout: UICollectionViewFlowLayout {
    
    var navigationHeight: CGFloat = 0
    
    override init() {
        super.init()
    }
    
    func update(tabLayout: TabHeaderFlowLayout?) {
        if let tabLayout = tabLayout {
            headerReferenceSize.height = tabLayout.headerReferenceSize.height
            sectionHeadersPinToVisibleBounds = tabLayout.sectionHeadersPinToVisibleBounds
            navigationHeight = tabLayout.navigationHeight
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func itemSize(frame: CGRect) {
        let headerHeight: CGFloat = sectionHeadersPinToVisibleBounds ? headerReferenceSize.height : 0
        itemSize = CGSize(width: frame.width, height: frame.height - headerHeight - navigationHeight)
    }
}

class TabHeaderFlowLayout: UICollectionViewFlowLayout {
    var backgroundHeaderColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var backgroundColorViewController: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    var navigationHeight: CGFloat = 64
    var transitionStyle: UIPageViewControllerTransitionStyle = .scroll
    
    override init() {
        super.init()    
        scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func itemSize(frame: CGRect) {
        itemSize = CGSize(width: frame.width, height: headerReferenceSize.height)
    }
}
