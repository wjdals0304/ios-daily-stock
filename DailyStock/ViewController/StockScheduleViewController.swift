//
//  StockScheduleViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/20.
//

import UIKit
import RealmSwift
import FSCalendar


class StockScheduleViewController: UIViewController {

    let localRealm = try! Realm()
    
    var tasks : Results<UserStockSchedule>!

    var startCalenderStart : Date?
    var endCalenderEnd: Date?
    
    var filteredDateTasks : Results<UserStockSchedule>!
    
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var tableView: UITableView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibName = UINib(nibName: StockScheduleTableViewCell.identifier, bundle: nibBundle)
        
        self.tableView.register(nibName, forCellReuseIdentifier: StockScheduleTableViewCell.identifier)
        
        self.tasks = localRealm.objects(UserStockSchedule.self)
        

        // calendar
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        calendar.headerHeight = 50
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        calendar.locale = Locale(identifier: "ko_KR")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    
}


extension StockScheduleViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockScheduleTableViewCell.identifier, for: indexPath) as? StockScheduleTableViewCell else { return UITableViewCell() }
        
        
        self.startCalenderStart = calendar.currentPage.add(days:1)!
        self.endCalenderEnd = calendar.currentPage.add(months:1)!
        
        self.filteredDateTasks = tasks.filter("alarmDate BETWEEN %@", [startCalenderStart,endCalenderEnd]).sorted(byKeyPath: "alarmDate" , ascending: true)

        
        if filteredDateTasks.count == 0   {
            return UITableViewCell()
        }
        

        let row = filteredDateTasks[indexPath.row]
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "dd E"
        
        cell.memoLabel.text = row.memo
        cell.alarmDateLabel.text = formatter.string(from: row.alarmDate)
        
        print(row.isAlarm)
        cell.alarmImage.image = row.isAlarm ? UIImage(systemName:  "bell.badge.fill" ) : UIImage(systemName: "bell.slash" )
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.startCalenderStart = calendar.currentPage.add(days:1)!
        self.endCalenderEnd = calendar.currentPage.add(months:1)!

        self.filteredDateTasks = tasks.filter("alarmDate BETWEEN %@", [startCalenderStart,endCalenderEnd])
        
        return filteredDateTasks.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
}

extension StockScheduleViewController :  FSCalendarDelegate, FSCalendarDataSource {
    
    
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
        
        
        let startCalenderStart = calendar.currentPage.add(days:1)!
        let endCalenderEnd = calendar.currentPage.add(months:1)!
        
        let filteredDateTasks = tasks.filter("alarmDate BETWEEN %@", [startCalenderStart,endCalenderEnd])
        
        var count = 0
    
        for task in filteredDateTasks {
            
            if format.string(from: task.alarmDate)  ==  format.string(from: date) {
                count += 1
            }
        }
        
        return count
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        tableView.reloadData()
    }
    
    
}


