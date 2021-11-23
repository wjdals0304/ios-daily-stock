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
    var memoData :  UserStockSchedule?
    
    @IBOutlet var titleText: UITextView!
    @IBOutlet var alarmDatePicker: UIDatePicker!
    @IBOutlet var alarmTF: UISwitch!
    @IBOutlet var memoText: UITextView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var alarmDateLabel: UILabel!
    @IBOutlet var alarmLabel: UILabel!
    @IBOutlet var memoLabel: UILabel!
    
    
    let userNotificationCenter = UNUserNotificationCenter.current()

    var alarmState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1).cgColor
        
        titleLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        
        
        alarmDateLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        alarmDateLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        
        alarmLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        alarmLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        
        memoLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        memoLabel.font = UIFont(name: "Roboto-Regular", size: 18)
        
        titleText.clipsToBounds = true
        titleText.layer.cornerRadius = 8
        titleText.layer.borderWidth = 1
        titleText.layer.borderColor = UIColor(red: 0.871, green: 0.878, blue: 0.913, alpha: 1).cgColor
        
        memoText.clipsToBounds = true
        memoText.layer.cornerRadius = 8
        memoText.layer.borderWidth = 1
        memoText.layer.borderColor = UIColor(red: 0.871, green: 0.878, blue: 0.913, alpha: 1).cgColor
        
        requestNotificationAuthorization()
        
        if memoData != nil {
            self.titleText.text = memoData?.titleName
            self.alarmDatePicker.setDate(memoData!.alarmDate, animated: true)
            self.alarmTF.isOn = memoData!.isAlarm
            self.memoText.text = memoData?.memo
        }
        
        
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
        
        let date = Date().addingTimeInterval(5)
        
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
