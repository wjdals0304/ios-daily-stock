//
//  SceneDelegate.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/17.
//

import UIKit
import IQKeyboardManagerSwift
import AppTrackingTransparency

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        // 탭바 폰트 사이즈 적용
        let tbltemProxy = UITabBarItem.appearance()
        print(tbltemProxy)
        tbltemProxy.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .normal)
        
        tbltemProxy.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)], for: .disabled)
        

        if let tbc = self.window?.rootViewController as? UITabBarController {
            tbc.tabBar.isTranslucent = false
            tbc.tabBar.barTintColor = UIColor(red: 0.93, green: 0.932, blue: 0.942, alpha: 1)
        }
        
        if let cc = self.window?.rootViewController as? UINavigationController {
            cc.navigationBar.isTranslucent = false
            cc.navigationBar.barTintColor = UIColor(red: 0.93, green: 0.932, blue: 0.942, alpha: 1)
        }
        
        
        //다크모드
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        

        
        
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
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//
//            ATTrackingManager.requestTrackingAuthorization { status in
//                switch status {
//
//                case .notDetermined:
//                    print("notDetermined")
//                    Analytics.setAnalyticsCollectionEnabled(true)
//                case .restricted:
//                    print("restricted")
//                    Analytics.setAnalyticsCollectionEnabled(true)
//
//                case .denied:
//                    print("denied")
//                    Analytics.setAnalyticsCollectionEnabled(true)
//
//                case .authorized:
//                    print("authoried")
//                    Analytics.setAnalyticsCollectionEnabled(true)
//
//                @unknown default:
//                    print("unknown")
//                }
//            }
//        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0

    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.

        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
    

}

