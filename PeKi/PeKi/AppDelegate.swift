//
//  AppDelegate.swift
//  PeKi
//
//  Created by 韩志峰 on 2023/4/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = NavigationViewController(rootViewController: RootViewController())
        window?.makeKeyAndVisible()
        return true
    }

    


}

