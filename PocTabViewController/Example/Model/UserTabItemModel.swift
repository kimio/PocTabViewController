//
//  UserTabItemModel.swift
//  PocTabViewController
//
//  Created by Felipe Kimio on 11/1/18.
//  Copyright © 2018 Felipe Kimio. All rights reserved.
//

import Foundation
import UIKit

struct UserTabItemModel: TabItemModel {
    var tabView: UIView
    var tabViewController: UIViewController
    var size: (percentage: CGFloat?, fixed: CGSize?)?
}
