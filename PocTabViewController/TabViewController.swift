//
//  TabViewController.swift
//  PocTabViewController
//
//  Created by Felipe Kimio on 9/3/18.
//  Copyright © 2018 Felipe Kimio. All rights reserved.
//

import UIKit

class TabViewHeader: UICollectionReusableView {
    
    private lazy var tabModel: [TabModel] = []
    weak var delegate: TabViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView(collectionViewController: TabViewController, tabModel: TabModel, initialIndex: Int) {
        
        let controller: TabViewController = TabViewController(headerWith: tabModel, initialIndex: initialIndex, collectionViewController: collectionViewController)
        controller.view.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        collectionViewController.addChildViewController(controller)
        
        controller.collectionView?.backgroundColor = tabModel.tabLayout.backgroundHeaderColor
        controller.delegate = delegate
        controller.didMove(toParentViewController: collectionViewController)
        addSubview(controller.view)
    }
}

extension TabViewController {
    
    private func setupFlowLayout() {
        if let flow: UICollectionViewFlowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flow.itemSize(frame: view.frame)
        }
    }
    
    private var tabViewHeader: (identifier: String, type: AnyClass) {
        return (String(describing: TabViewHeader.self), TabViewHeader.self)
    }
    
    private var tabViewCell: (identifier: String, type: AnyClass) {
        return (String(describing: TabViewCell.self), TabViewCell.self)
    }
    
    private func registerTabViewHeader() {
        collectionView?.register(tabViewHeader.type,
                                 forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                 withReuseIdentifier: tabViewHeader.identifier)
    }
    
    private func registerTabViewCell() {
        collectionView?.register(tabViewCell.type, forCellWithReuseIdentifier: tabViewCell.identifier)
    }
}

extension TabViewController: TabViewCellDelegate {
    func selectIndexTab(from: Int, to: Int) {
        (pageViewController?.parent as? TabViewController)?.collectionHeader?.collectionView?.scrollToItem(at: IndexPath(row: to, section: 0),
                                                                                                           at: .left,
                                                                                                           animated: true)
    }
}

extension TabViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if building == .tabs,
            model.items.count > indexPath.row,
            let size = model.items[indexPath.row].size {
            if let fixed = size.fixed {
                return fixed
            }
            if let percentage = size.percentage {
                let width: CGFloat = collectionView.frame.width * percentage
                return CGSize(width: width, height: collectionView.frame.height)
            }
        }
        return (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
    }
}

class TabViewController: UICollectionViewController {
    
    enum Building {
        case viewController
        case tabs
    }
    
    lazy var collectionHeader: TabViewController? = nil
    var pageViewController: UIPageViewController?
    
    private var initialIndex: Int = 0
    private var model: TabModel = TabModel()
    private var building: Building = .viewController
    private var scrollHeaderCell: Bool = true
    weak var delegate: TabViewControllerDelegate?
    
    init(model: TabModel, initialIndex: Int = 0) {
        let tabFlowLayout: TabViewControllerFlowLayout = TabViewControllerFlowLayout()
        tabFlowLayout.update(tabLayout: model.tabLayout)
        super.init(collectionViewLayout: tabFlowLayout)
        collectionView?.backgroundColor = model.tabLayout.backgroundColorViewController
        self.model = model
        self.initialIndex = initialIndex
        registerTabViewHeader()
    }
    
    fileprivate init(headerWith model: TabModel, initialIndex: Int, collectionViewController: TabViewController) {
        super.init(collectionViewLayout: model.tabLayout)
        building = .tabs
        self.initialIndex = initialIndex
        self.model = model
        collectionViewController.collectionHeader = self
        pageViewController = collectionViewController.pageViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTabViewCell()
        setupFlowLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if scrollHeaderCell,
            building == .tabs,
            initialIndex > -1,
            initialIndex < model.items.count {
            collectionView?.scrollToItem(at: IndexPath(row: initialIndex, section: 0),
                                         at: .left,
                                         animated: false)
            scrollHeaderCell = false
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tabViewCell.identifier, for: indexPath) as? TabViewCell {
            cell.setupView(tabViewController: self, tabModel: model, indexPath: indexPath, building: building, initialIndex: initialIndex)
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if building == .tabs, let delegate = delegate, indexPath.row < model.items.count {
                collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
                
            guard let currentIndexPage: Int = (pageViewController?.viewControllers?.first as? TabController)?.tabIndex,
                indexPath.row != currentIndexPage else {
                return
            }
            
            let direction: UIPageViewControllerNavigationDirection = indexPath.row > currentIndexPage ? .forward : .reverse
            let viewController: UIViewController = model.items[indexPath.row].tabViewController
            
            delegate.willSelectItem(tabModel: model, from: currentIndexPage, to: indexPath.row)
            pageViewController?.setViewControllers([viewController],
                                                   direction: direction,
                                                   animated: true,
                                                   completion: { (result) in
                                                    delegate.didSelectItem(tabModel: self.model, from: currentIndexPage, to: indexPath.row)
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return building == .viewController ? 1 : model.items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: tabViewHeader.identifier, for: indexPath) as? TabViewHeader {
                header.delegate = delegate
                header.setupView(collectionViewController: self, tabModel: model, initialIndex: initialIndex)
                return header
            }
        }
        return UICollectionReusableView()
    }
    
}
