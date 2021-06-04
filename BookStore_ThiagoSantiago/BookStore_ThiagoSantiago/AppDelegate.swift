//
//  AppDelegate.swift
//  BookStore_ThiagoSantiago
//
//  Created by Thiago Santiago on 29/05/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let router = AppRouter.shared
                
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = router.navigation
        window?.makeKeyAndVisible()
        
        router.routeToBooksList()
                
        return true
    }
}

