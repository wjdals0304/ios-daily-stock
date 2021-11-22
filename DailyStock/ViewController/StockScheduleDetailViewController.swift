//
//  StockScheduleDetailViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/20.
//

import UIKit
import RealmSwift
import UserNotifications



class StockScheduleDetailViewController: UIViewController {

    let localRealm = try! Realm()
    var tasks : Results<UserStockSchedule>!
    
    @IBOutlet var titleText: UITextView!
    @IBOutlet var alarmDatePicker: UIDatePicker!
    @IBOutlet var alarmTF: UISwitch!
    @IBOutlet var memoText: UITextView!
    
    
    
    let userNotificationCenter = UNUserNotificationCenter.current()

    var alarmState = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestNotificationAuthorization()
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        if UserDefaults.standard.bool(forKey: "alarmState") == true {
            sendNotification()
        }
        
        
        let task = UserStockSchedule(titleName: titleText.text, isAlarm:  alarmTF.isOn , alarmDate: alarmDatePicker.date, memo: memoText.text, writeDate: Date())
        
        try! localRealm.write {
            localRealm.add(task)
        }
        
            
    }
    
    

    func requestNotificationAuthorization() {
        
        let authOpthions = UNAuthorizationOptions(arrayLiteral: .alert,.badge,.sound)
        
            userNotificationCenter.requestAuthorization(options: authOpthions) {
                success, error in
                if success {
                    UserDefaults.standard.set( true , forKey : "alarmState")
                }
            }
    }
    
    
    func sendNotification(){
        
        
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = "물 마실 시간이에요!"
        notificationContent.body = "하루 2리터 목표 달성을 위해 열심히 달려보아요"
        notificationContent.badge = 1
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let alarmDatePicker = formatter.string(from: alarmDatePicker.date)
        let resultDatePicker = formatter.date(from: alarmDatePicker)
        
        print(resultDatePicker)
        
        let date = Date().addingTimeInterval(3)
        print(date)
        
        let dateComponets = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponets, repeats: false)
            
        let request = UNNotificationRequest(identifier: "\(Date())",
                                                 content: notificationContent,
                                                 trigger: trigger)
            
        userNotificationCenter.add(request) { error in
            if let error = error {
                            print("Notification Error: ", error)
                        }
            }
            
    
    }
    
}
