//
//  TabModel.swift
//  PocTabViewController
//
//  Created by Felipe Kimio on 9/3/18.
//  Copyright © 2018 Felipe Kimio. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionItem {
    var size: (percentage: CGFloat?, fixed: CGSize?)? { get set }
}

protocol TabView {
    func setupView()
}

protocol TabItemModel: CollectionItem {
    var tabView: UIView { get set }
    var tabViewController: UIViewController { get set }
}

struct TabModel {
    var items: [TabItemModel] = []
    var tabLayout: TabHeaderFlowLayout = TabHeaderFlowLayout()
    
    init() { }
    
    init(items: [TabItemModel], tabLayout: TabHeaderFlowLayout) {
        self.items = items
        self.tabLayout = tabLayout
    }
    
    func indexItemOf(_ viewController: UIViewController?) -> Int {
        return items.firstIndex { (itemModel) -> Bool in
            return itemModel.tabViewController == viewController
            } ?? 0
    }
}

struct UserTabItemModel: TabItemModel {
    var tabView: UIView
    var tabViewController: UIViewController
    var size: (percentage: CGFloat?, fixed: CGSize?)?
}
