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
    
    func didSelectItem(collectionView: UICollectionView, from: Int, to: Int)
    func willSelectItem(collectionView: UICollectionView, from: Int, to: Int)
}
