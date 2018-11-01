//
//  AppDelegate.swift
//  PocTabViewController
//
//  Created by Felipe Kimio on 9/3/18.
//  Copyright © 2018 Felipe Kimio. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TabViewControllerDelegate {
    
    let spaceXp: String = " XP"
    let space8p: String = " :P"
    
    private func clearText(text: String?) -> String? {
        var newText: String? = text
        [spaceXp, space8p].forEach({ (remove) in
            newText = newText?.replacingOccurrences(of: remove, with: "")
        })
        return newText
    }
    
    func didSelectItem(tabModel: TabModel, from: Int, to: Int) {
        if let label = (tabModel.items[to].tabView as? Tab)?.label,
            let text = clearText(text: label.text) {
            label.text = "\(text)\(space8p)"
        }
    }
    
    func willSelectItem(tabModel: TabModel, from: Int, to: Int) {
        if let label = (tabModel.items[from].tabView as? Tab)?.label,
            let text = clearText(text: label.text) {
            label.text = "\(text)\(spaceXp)"
        }
    }
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let tab1 = Tab()
        tab1.label.text = "tab1"
        tab1.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        
        let tab2 = Tab()
        tab2.label.text = "tab2"
        tab2.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        let tab3 = Tab()
        tab3.label.text = "tab3"
        tab3.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        
        let body1 = BodyViewController()
        body1.view.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        body1.label.text = "Body 1"
        
        let body2 = BodyViewController()
        body2.view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        body2.label.text = "Body 2"
        
        let body3 = BodyViewController()
        body3.view.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        body3.label.text = "Body 3"
        
        let items = [
            UserTabItemModel(tabView: tab1,
                             tabViewController: body1,
                             size: (percentage: 1, fixed: nil)),
            
            UserTabItemModel(tabView: tab2,
                             tabViewController: body2,
                             size: (percentage: 0.5, fixed: nil)),
            
            UserTabItemModel(tabView: tab3,
                             tabViewController: body3,
                             size: (percentage: 1, fixed: nil))
        ]
        
        let tabModel = TabModel(items: items, headerLayout: TabHeaderLayout(), controllerLayout: TabControllerLayout())
        let tabViewController = TabViewController(model: tabModel, initialIndex: 1)
        tabViewController.delegate = self
        window?.rootViewController = UINavigationController(rootViewController: tabViewController)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
}

