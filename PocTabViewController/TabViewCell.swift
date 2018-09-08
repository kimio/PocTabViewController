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
    
    private var tabViewModel: TabModel = TabModel()
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
        
        var tabItems: [TabItemModel] = tabModel.items
        for index in 0..<tabItems.count {
            tabItems[index].tabViewController.tabIndex = index
        }
        var index: Int = 0
        if  initialIndex < tabModel.items.count,
            initialIndex > -1 {
            index = initialIndex
        }
        let viewController = tabModel.items[index].tabViewController
        tabViewModel = tabModel
        tabViewController.pageViewController = UIPageViewController(transitionStyle: tabModel.tabLayout.transitionStyle, navigationOrientation: .horizontal, options: nil)
        guard let pageViewController: UIPageViewController = tabViewController.pageViewController else {
            return
        }
        pageViewController.delegate = self
        pageViewController.setViewControllers([viewController], direction: .forward, animated: false, completion: nil)
        
        pageViewController.dataSource = self
        
        tabViewController.addChildViewController(pageViewController)
        addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: tabViewController)
    }
    
    private func indexOfViewController(_ viewController: TabController) -> Int {
        return viewController.tabIndex
    }
    
    private func transitionPageViewController(_ pageViewController: UIPageViewController, fromViewControllers: [UIViewController], toViewControllers: [UIViewController], transition: (UICollectionView, TabViewControllerDelegate, Int, Int) -> Void) {
        
        if let parentTabController = (pageViewController.parent as? TabViewController),
            let delegate = parentTabController.delegate,
            let collectionView = parentTabController.collectionHeader?.collectionView {
            
            let from: Int = (fromViewControllers.first as! TabController).tabIndex
            let to: Int = (toViewControllers.first as! TabController).tabIndex
            
            transition(collectionView, delegate, from, to)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let fromViewControllers = pageViewController.viewControllers {
            transitionPageViewController(pageViewController, fromViewControllers: fromViewControllers, toViewControllers: pendingViewControllers, transition: { (collectionView, delegate, from, to) in
                delegate.willSelectItem(tabModel: tabViewModel, from: from, to: to)
            })
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let internalDelegate = delegate,
            let toViewControllers = pageViewController.viewControllers {
            transitionPageViewController(pageViewController, fromViewControllers: previousViewControllers, toViewControllers: toViewControllers, transition: { (collectionView, delegate, from, to) in
                internalDelegate.selectIndexTab(from: from, to: to)
                delegate.didSelectItem(tabModel: tabViewModel, from: from, to: to)
            })
        }
    }
    
    private func viewControllerOfIndex(_ pageViewController: UIPageViewController, _ index: Int) -> UIViewController? {
        guard tabViewModel.items.count > index,
            index > -1 else {
                return nil
        }
        return tabViewModel.items[index].tabViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index: Int = indexOfViewController(viewController as! TabController)
        return viewControllerOfIndex(pageViewController, index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index: Int = indexOfViewController(viewController as! TabController)
        return viewControllerOfIndex(pageViewController, index + 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
