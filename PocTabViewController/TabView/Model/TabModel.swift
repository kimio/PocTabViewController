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

public struct TabModel {
    var items: [TabItemModel] = []
    var headerLayout: TabHeaderFlowLayout = TabHeaderFlowLayout()
    var controllerLayout: TabViewControllerFlowLayout = TabViewControllerFlowLayout()
    
    init() { }
    
    init(items: [TabItemModel],
         headerLayout: TabHeaderFlowLayout = TabHeaderFlowLayout(),
         controllerLayout: TabViewControllerFlowLayout = TabViewControllerFlowLayout()) {
        self.items = items
        self.headerLayout = headerLayout
        self.controllerLayout = controllerLayout
    }
    
    func indexItemOf(_ viewController: UIViewController?) -> Int {
        return items.firstIndex { (itemModel) -> Bool in
            return itemModel.tabViewController == viewController
            } ?? 0
    }
}
