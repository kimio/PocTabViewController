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

class TabController: UIViewController {
    var tabIndex: Int = 0
}

protocol TabView {
    func setupView()
}

protocol TabItemModel: CollectionItem {
    var tabView: UIView { get set }
    var tabViewController: TabController { get set }
}

struct TabModel {
    var items: [TabItemModel] = []
    var tabLayout: TabHeaderFlowLayout = TabHeaderFlowLayout()
    
    init() { }
    
    init(items: [TabItemModel], tabLayout: TabHeaderFlowLayout) {
        self.items = items
        self.tabLayout = tabLayout
    }
}

struct UserTabItemModel: TabItemModel {
    var tabView: UIView
    
    var tabViewController: TabController
    
    var size: (percentage: CGFloat?, fixed: CGSize?)?
}
