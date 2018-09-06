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
    
    private var tabViewModel: TabModel?
    weak var delegate: TabViewCellDelegate?
    
    func setupView(collectionViewController: TabViewController, tabModel: TabModel, indexPath: IndexPath, building: TabViewController.Building) {
        if tabModel.items.count < indexPath.row {
            return
        }
        let itemModel = tabModel.items[indexPath.row]
        switch building {
        case .tabs:
            createHeaderView(itemModel: itemModel)
        case .viewController:
            delegate = collectionViewController
            createViewController(collectionViewController: collectionViewController, itemModel: itemModel, tabModel: tabModel)
        }
    }
    
    private func createHeaderView(itemModel: TabItemModel) {
        itemModel.tabView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addSubview(itemModel.tabView)
    }
    
    private func createViewController(collectionViewController: TabViewController, itemModel: TabItemModel, tabModel: TabModel) {
        
        var tabItems: [TabItemModel] = tabModel.items
        for index in 0..<tabItems.count {
            tabItems[index].tabViewController.tabIndex = index
        }
        
        if  let firstItem = tabModel.items.first {
            tabViewModel = tabModel
            collectionViewController.pageViewController = TabViewPage(transitionStyle: tabModel.tabLayout.transitionStyle, navigationOrientation: .horizontal, options: nil)
            guard let pageViewController: TabViewPage = collectionViewController.pageViewController else {
                return
            }
            pageViewController.delegate = self
            pageViewController.setViewControllers([firstItem.tabViewController], direction: .forward, animated: false, completion: {done in })
            
            pageViewController.dataSource = self
            
            collectionViewController.addChildViewController(pageViewController)
            addSubview(pageViewController.view)
            pageViewController.didMove(toParentViewController: collectionViewController)
        }
    }
    
    private func indexOfViewController(_ viewController: TabController) -> Int {
        return viewController.tabIndex
    }
    
    private func transitionPageViewController(_ pageViewController: UIPageViewController, fromViewControllers: [UIViewController], toViewControllers: [UIViewController]) -> (collectionView: UICollectionView, delegate: TabViewControllerDelegate, from: Int, to: Int)? {
        
        guard let parentTabController = (pageViewController.parent as? TabViewController),
            let delegate = parentTabController.delegate,
            let collectionView = parentTabController.collectionHeader?.collectionView else {
                return nil
        }
        let from: Int = (fromViewControllers.first as! TabController).tabIndex
        let to: Int = (toViewControllers.first as! TabController).tabIndex
        
        return (collectionView: collectionView, delegate: delegate, from: from, to: to)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let fromViewControllers = pageViewController.viewControllers,
            let (collectionView, delegate, from, to) = transitionPageViewController(pageViewController, fromViewControllers: fromViewControllers, toViewControllers: pendingViewControllers) {
            delegate.willSelectItem(collectionView: collectionView, from: from, to: to)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let internalDelegate = delegate else {
            return
        }
        
        if let toViewControllers = pageViewController.viewControllers,
            let (collectionView, delegate, from, to) = transitionPageViewController(pageViewController, fromViewControllers: previousViewControllers, toViewControllers: toViewControllers) {
            internalDelegate.selectIndexTab(from: from, to: to)
            delegate.didSelectItem(collectionView: collectionView, from: from, to: to)
        }
    }
    
    private func viewControllerOfIndex(_ pageViewController: UIPageViewController, _ index: Int) -> UIViewController? {
        guard let tabViewModel: TabModel = tabViewModel,
            tabViewModel.items.count > index,
            index > -1 else {
                return nil
        }
        (pageViewController as? TabViewPage)?.currentIndexPage = index
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
