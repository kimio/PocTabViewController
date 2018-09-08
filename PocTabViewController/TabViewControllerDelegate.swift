//
//  TabViewControllerDelegate.swift
//  PocTabViewController
//
//  Created by Felipe Kimio on 9/5/18.
//  Copyright © 2018 Felipe Kimio. All rights reserved.
//

import Foundation
import UIKit

protocol TabViewControllerDelegate: class {
    func didSelectItem(tabModel: TabModel, from: Int, to: Int)
    func willSelectItem(tabModel: TabModel, from: Int, to: Int)
}
