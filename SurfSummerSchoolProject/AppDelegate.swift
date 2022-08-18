//
//  AppDelegate.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 02.08.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    //MARK: - UIApplication
    var window: UIWindow?
    var tokenStorage: TokenStorage {
        BaseTokenStorage()
    }
    let lauchScreenStoryBoard = UIStoryboard(name: "LaunchScreen", bundle: .main)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        startApplicationProccess()
        return true
    }
    //MARK: - Methods
    func startApplicationProccess() {
        runLaunchScreen()
        
        if let tokenContainer = try? tokenStorage.getToken(), !tokenContainer.isExpired {
            runMainFlow()
        } else {
            runAuthFlow()
        }
    }
    func runMainFlow() {
        DispatchQueue.main.async {
            self.window?.rootViewController = TabBarConfigurator().configure()
        }
    }
    func runAuthFlow() {
        DispatchQueue.main.async {
            let authVC = AuthViewController()
            let navigationController = UINavigationController(rootViewController: authVC)
            self.window?.rootViewController = navigationController
        }
    }
    
    func runLaunchScreen() {
        let lauchScreenViewController = lauchScreenStoryBoard
            .instantiateInitialViewController()
        window?.rootViewController = lauchScreenViewController
    }
}

