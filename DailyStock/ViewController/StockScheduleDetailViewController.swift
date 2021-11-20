//
//  StockScheduleDetailViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/20.
//

import UIKit
import RealmSwift



class StockScheduleDetailViewController: UIViewController {

    let localRealm = try! Realm()
    var tasks : Results<UserStockSchedule>!
    
    @IBOutlet var titleText: UITextView!
    
    @IBOutlet var alarmDatePicker: UIDatePicker!
    
    @IBOutlet var alarmTF: UISwitch!
    
    
    @IBOutlet var memoText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        let task = UserStockSchedule(titleName: titleText.text, isAlarm:  alarmTF.isOn , alarmDate: alarmDatePicker.date, memo: memoText.text, writeDate: Date())
        
        try! localRealm.write{
            localRealm.add(task)
        }
        
        
    }
    

    
    
}
