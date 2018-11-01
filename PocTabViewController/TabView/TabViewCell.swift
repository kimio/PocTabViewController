//
//  TabViewCell.swift
//  PocTabViewController
//
//  Created by Felipe Kimio on 9/6/18.
//  Copyright © 2018 Felipe Kimio. All rights reserved.
//

import Foundation
import UIKit

protocol TabViewCellDelegate: class {
    func selectIndexTab(from: Int, to: Int)
}

class TabViewCell: UICollectionViewCell, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private var tabModel: TabModel = TabModel()
    weak var delegate: TabViewCellDelegate?
    
    func setupView(tabViewController: TabViewController, tabModel: TabModel, indexPath: IndexPath, building: TabViewController.Building, initialIndex: Int) {
        if tabModel.items.count < indexPath.row {
            return
        }
        let itemModel = tabModel.items[indexPath.row]
        switch building {
        case .tabs:
            createHeaderView(itemModel: itemModel)
        case .viewController:
            delegate = tabViewController
            createViewController(tabViewController: tabViewController, itemModel: itemModel, tabModel: tabModel, initialIndex: initialIndex)
        }
    }
    
    private func createHeaderView(itemModel: TabItemModel) {
        itemModel.tabView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(itemModel.tabView)
    }
    
    private func createViewController(tabViewController: TabViewController, itemModel: TabItemModel, tabModel: TabModel, initialIndex: Int) {
        self.tabModel = tabModel
        var index: Int = 0
        if  initialIndex < tabModel.items.count,
            initialIndex > -1 {
            index = initialIndex
        }
        let viewController: UIViewController = tabModel.items[index].tabViewController
        tabViewController.pageViewController = UIPageViewController(transitionStyle: tabModel.controllerLayout.transitionStyle, navigationOrientation: .horizontal, options: nil)
        guard let pageViewController: UIPageViewController = tabViewController.pageViewController else {
            return
        }
        let frame: CGRect = pageViewController.view.frame
        pageViewController.view.frame = CGRect(x: frame.origin.x,
                                               y: frame.origin.y,
                                               width: tabModel.controllerLayout.itemSize.width,
                                               height: tabModel.controllerLayout.itemSize.height)
        pageViewController.delegate = self
        pageViewController.setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
        pageViewController.dataSource = self
        
        tabViewController.addChildViewController(pageViewController)
        addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: tabViewController)
    }
    
    private func transitionPageViewController(_ pageViewController: UIPageViewController, fromViewControllers: [UIViewController], toViewControllers: [UIViewController], transition: (UICollectionView, TabViewControllerDelegate, Int, Int) -> Void) {
        
        if let parentTabController = (pageViewController.parent as? TabViewController),
            let delegate = parentTabController.delegate,
            let collectionView = parentTabController.collectionHeader?.collectionView {
            
            let from: Int = tabModel.indexItemOf(fromViewControllers.first)
            let to: Int = tabModel.indexItemOf(toViewControllers.first)
            transition(collectionView, delegate, from, to)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let fromViewControllers = pageViewController.viewControllers {
            transitionPageViewController(pageViewController, fromViewControllers: fromViewControllers, toViewControllers: pendingViewControllers, transition: { (collectionView, delegate, from, to) in
                delegate.willSelectItem(tabModel: tabModel, from: from, to: to)
            })
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let internalDelegate = delegate,
            let toViewControllers = pageViewController.viewControllers {
            transitionPageViewController(pageViewController, fromViewControllers: previousViewControllers, toViewControllers: toViewControllers, transition: { (collectionView, delegate, from, to) in
                internalDelegate.selectIndexTab(from: from, to: to)
                delegate.didSelectItem(tabModel: tabModel, from: from, to: to)
            })
        }
    }
    
    private func viewControllerOfIndex(_ pageViewController: UIPageViewController, _ index: Int) -> UIViewController? {
        guard tabModel.items.count > index,
            index > -1 else {
                return nil
        }
        return tabModel.items[index].tabViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return viewControllerOfIndex(pageViewController, tabModel.indexItemOf(viewController) - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return viewControllerOfIndex(pageViewController, tabModel.indexItemOf(viewController) + 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
