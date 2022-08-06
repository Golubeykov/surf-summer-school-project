//
//  TabBarConfigurator.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 04.08.2022.
//

import Foundation
import UIKit

class TabBarConfigurator {
    private let allTabs: [TabBarModel] = [.allPosts, .favoritePosts, .profile]
    
    func configure() -> UITabBarController {
        return constructTabBarController()
    }
}

private extension TabBarConfigurator {
    func constructTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.viewControllers = getControllers()
        return tabBarController
    }
    
    func getControllers() -> [UIViewController] {
        var viewControllers = [UIViewController]()
        
        allTabs.forEach { tab in
            let viewController = getCurrentViewController(tab: tab)
            let navigationController = UINavigationController(rootViewController: viewController)
            let tabBarItem = UITabBarItem(title: tab.title, image: tab.image, selectedImage: tab.selectedImage)
            viewController.tabBarItem = tabBarItem
            viewControllers.append(navigationController)
        }
        return viewControllers
    }
    
    func getCurrentViewController(tab: TabBarModel) -> UIViewController {
        switch tab {
        case .allPosts:
            return AllPostsViewController()
        case .favoritePosts:
            return FavoritePostsViewController()
        case .profile:
            return ProfileViewController()
        }
    }
}
