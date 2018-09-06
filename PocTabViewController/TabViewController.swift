//
//  TabViewController.swift
//  PocTabViewController
//
//  Created by Felipe Kimio on 9/3/18.
//  Copyright © 2018 Felipe Kimio. All rights reserved.
//

import UIKit

class TabViewPage: UIPageViewController {
    var currentIndexPage: Int = 0
}

class TabViewHeader: UICollectionReusableView {
    
    private lazy var tabModel: [TabModel]? = nil
    weak var delegate: TabViewControllerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView(collectionViewController: TabViewController, tabModel: TabModel?) {
        guard let tabModel: TabModel = tabModel else {
            return
        }
        let controller: TabViewController = TabViewController(headerWith: tabModel, collectionViewController: collectionViewController)
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

class TabViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, TabViewCellDelegate {
    
    enum Building {
        case viewController
        case tabs
    }
    
    lazy var collectionHeader: TabViewController? = nil
    var pageViewController: TabViewPage?
    private var model: TabModel?
    private var building: Building = .viewController
    weak var delegate: TabViewControllerDelegate?
    
    init(model: TabModel?) {
        let tabFlowLayout: TabViewControllerFlowLayout = TabViewControllerFlowLayout()
        tabFlowLayout.update(tabLayout: model?.tabLayout)
        super.init(collectionViewLayout: tabFlowLayout)
        collectionView?.backgroundColor = model?.tabLayout.backgroundColorViewController
        self.model = model
        registerTabViewHeader()
    }
    
    fileprivate init(headerWith model: TabModel, collectionViewController: TabViewController) {
        let tabHeaderLayout: TabHeaderFlowLayout = model.tabLayout
        super.init(collectionViewLayout: tabHeaderLayout)
        building = .tabs
        self.model = model
        collectionViewController.collectionHeader = self
        pageViewController = collectionViewController.pageViewController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectIndexTab(from: Int, to: Int) {
        
        let scrollPosition: UICollectionViewScrollPosition = from < to ? .right : .left
        (pageViewController?.parent as? TabViewController)?.collectionHeader?.collectionView?.scrollToItem(at: IndexPath(row: to, section: 0),
                                                                                                           at: scrollPosition,
                                                                                                           animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTabViewCell()
        setupFlowLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tabViewCell.identifier, for: indexPath) as? TabViewCell, let model = model {
            cell.setupView(collectionViewController: self, tabModel: model, indexPath: indexPath, building: building)
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if building == .tabs, let delegate = delegate {
            
            guard let model = model else {
                return
            }
            if indexPath.row < model.items.count {
                collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
                
                guard let currentIndexPage: Int = pageViewController?.currentIndexPage,
                    indexPath.row != currentIndexPage else {
                        return
                }
                
                delegate.willSelectItem(collectionView: collectionView, from: currentIndexPage, to: indexPath.row)
                let direction: UIPageViewControllerNavigationDirection = indexPath.row > currentIndexPage ? .forward : .reverse
                let viewController: UIViewController = model.items[indexPath.row].tabViewController
                
                pageViewController?.setViewControllers([viewController],
                                                       direction: direction,
                                                       animated: true,
                                                       completion: { (result) in
                                                        self.pageViewController?.currentIndexPage = indexPath.row
                                                        
                                                        delegate.didSelectItem(collectionView: collectionView, from: currentIndexPage, to: indexPath.row)
                })
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if building == .tabs,
            let items = model?.items,
            items.count > indexPath.row,
            let size = items[indexPath.row].size {
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = model?.items else {
            return 0
        }
        return building == .viewController ? 1 : items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            if let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: tabViewHeader.identifier, for: indexPath) as? TabViewHeader {
                header.delegate = delegate
                header.setupView(collectionViewController: self, tabModel: model)
                return header
            }
        }
        return UICollectionReusableView()
    }
    
    
}

