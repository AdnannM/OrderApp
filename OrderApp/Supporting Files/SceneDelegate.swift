//
//  SceneDelegate.swift
//  OrderApp
//
//  Created by Adnann Muratovic on 24.12.21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var orderTabBarItem: UITabBarItem!

    func scene(_ scene: UIScene, willConnectTo session:
               UISceneSession, options connectionOptions:
               UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateOrderBadge),
                                               name: MenuController.orderUpdateNotification, object: nil)
        orderTabBarItem = (window?.rootViewController as?
                           UITabBarController)?.viewControllers?[1].tabBarItem
        
        if let userActivity =
            connectionOptions.userActivities.first ??
            session.stateRestorationActivity {
            configureScene(for: userActivity)
        }
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return MenuController.shared.userActivity
    }
    
    func configureScene(for userActivity: NSUserActivity) {
        if let restoredOrder = userActivity.order {
            MenuController.shared.order = restoredOrder
        }
        
        guard
            let restorationController =
               StateRestorantionController(userActiviry: userActivity),
            let tabBarController = window?.rootViewController as?
               UITabBarController,
                tabBarController.viewControllers?.count == 2,
            let categoryTableViewController =
               (tabBarController.viewControllers?[0] as?
               UINavigationController)?.topViewController as?
               CategoryTableViewController
        else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch restorationController {
        case .categories:
            break
        case .order:
            tabBarController.selectedIndex = 1
        case .menu(category: let category):
            let menuTableViewController = storyboard.instantiateViewController(identifier: restorationController.identifier.rawValue) { coder in
                return MenuTableViewController(coder: coder, categories: category)
            }
            
            categoryTableViewController.navigationController?.pushViewController(menuTableViewController, animated: true)
            
        case .menuItemDetail(let menuItem):
            let menuTableViewController = storyboard.instantiateViewController(identifier: StateRestorantionController.Identifier.menu.rawValue) { coder in
                return MenuTableViewController(coder: coder, categories: menuItem.category)
            }
            
            let menuItemDetailViewController = storyboard.instantiateViewController(identifier: restorationController.identifier.rawValue) { coder in
                return MenuDetailViewController(coder: coder, menuItem: menuItem)
            }
            
            categoryTableViewController.navigationController?.pushViewController(menuTableViewController, animated: true)
            categoryTableViewController.navigationController?.pushViewController(menuItemDetailViewController, animated: true)
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

 // MARK: - Action
extension SceneDelegate {
    @objc func updateOrderBadge() {
        switch MenuController.shared.order.menuItems.count {
        case 0:
            orderTabBarItem.badgeValue = nil
            
        case let count:
            orderTabBarItem.badgeValue = String(count)
        }
    }
}

