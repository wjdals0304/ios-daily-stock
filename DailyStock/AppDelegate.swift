//
//  AppDelegate.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/17.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate  {
    
//    , GIDSignInDelegate
    // 세로모드만 적용 
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Firebase 초기화 , 공유 인스턴스 생성
//g
        //google login
//        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate = self

        
        UNUserNotificationCenter.current().delegate = self

        //탭바 백그라운드
        if #available(iOS 15.0, *){
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            UITabBar.appearance().backgroundColor = UIColor(red: 0.93, green: 0.932, blue: 0.942, alpha: 1)

        }
        //Crashlytics
        
        //ATT Framework
        
    
        return true
    }
    
    // 앱이 수신하는 URL를 처리
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance().handle(url)
//    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//
//        if let error = error {
//            print("ERROR Google Sign IN \(error.localizedDescription)")
//            return
//        }
//
//        guard let authentication = user.authentication else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
//
//        Auth.auth().signIn(with: credential) { _, _ in
//            self.showMainViewController()
//        }
//    }
    
//    private func showMainViewController() {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let mainViewController = storyboard.instantiateViewController(withIdentifier: "startView")
//        mainViewController.modalPresentationStyle = .fullScreen
//        UIApplication.shared.windows.first?.rootViewController?.show(mainViewController, sender: nil)
//
//    }


}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // 3. 앱이 foreground상태 일 때, 알림이 온 경우 어떻게 표현할 것인지 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        // 푸시가 오면 alert, badge, sound표시를 하라는 의미
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "StockSchedule") as? StockScheduleViewController,
           let tabBar = rootViewController as? UITabBarController,
           let navVC = tabBar.selectedViewController as? UINavigationController {
            tabBar.selectedIndex = 2
            navVC.pushViewController(vc, animated: true)
        }
        
        
    }
        
    
 }
