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
    
    var selectedBool : Bool = false
    
    let userNotificationCenter = UNUserNotificationCenter.current()

    var alarmState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1).cgColor
        
        titleLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        
        alarmDateLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        alarmDateLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        
        alarmLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        alarmLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        
        memoLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        memoLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        
        alarmLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        alarmLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        
        
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
            self.selectedBool = true
        }
        alarmDatePicker.locale = Locale(identifier: "ko-KR")
        
    }
    
    @objc func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        guard self.titleText.text?.isEmpty == false
        else {
            
            let alert = UIAlertController(title: nil, message: "종목이름을 입력해주세요.", preferredStyle: .alert )
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        if self.selectedBool == true {
            
            let task = localRealm.objects(UserStockSchedule.self).filter( "_id = %@",memoData!._id).first
            
            // 알람 삭제
            if task?.isAlarm == false {
                removeSendNofi(schedulUUID: task!.scheduleUUID)
            }
            
            // 시간 변경시 알람 변경
            if alarmDatePicker.date != task?.alarmDate {
                sendNotification(scheduleUUID: task!.scheduleUUID, alarmTitle: titleText.text, alarmDate: alarmDatePicker.date)
            }
            
            try! localRealm.write{
                
                task?.titleName = titleText.text
                task?.isAlarm = alarmTF.isOn
                task?.alarmDate = alarmDatePicker.date
                task?.memo = memoText.text
                task?.writeDate = Date()
                
            }
            
        } else {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            
            let scheduleUUID = UUID().uuidString
            
            let alarmStrToDate = dateFormatter.string(from: alarmDatePicker.date )
            
            let task = UserStockSchedule(titleName: titleText.text, isAlarm:  alarmTF.isOn , alarmDate: alarmDatePicker.date, memo: memoText.text , calendarDate: alarmStrToDate , writeDate: Date(),scheduleUUID: scheduleUUID)
            
            if UserDefaults.standard.bool(forKey: "alarmState") == true {
                sendNotification(scheduleUUID: scheduleUUID , alarmTitle: titleText.text , alarmDate: alarmDatePicker.date)
            }
                   
            try! localRealm.write {
                localRealm.add(task)

            }
        }
        
        self.dismiss(animated: true, completion: nil)
        
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
    
    
    func sendNotification(scheduleUUID : String , alarmTitle : String, alarmDate : Date){
        
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = alarmTitle
        notificationContent.badge = 1

        
        let dateComponets = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alarmDate)
            
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponets, repeats: false)
            
        let request = UNNotificationRequest(identifier: scheduleUUID ,
                                                 content: notificationContent,
                                                 trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                            print("Notification Error: ", error)
                        }
            }
    }
    
    /// local notification active swift
    /// willpresent appdelgate:
    /// badge 처리
    
    func removeSendNofi(schedulUUID: String) {
        
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers:[schedulUUID])
        
    }
    
    
}
