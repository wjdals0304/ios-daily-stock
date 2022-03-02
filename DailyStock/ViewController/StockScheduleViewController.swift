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
    
    lazy var addBarButton : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didAddBarButtonClicked(_:)))
        return barButtonItem
    }()
    
    @objc func didAddBarButtonClicked(_ sender : UIBarButtonItem) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StockScheduleDetailViewController") as! StockScheduleDetailViewController
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav,animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendar.reloadData()
        tableView.reloadData()
    }
    
    func setup() {
        
        self.navigationItem.title = "일정관리"
        self.navigationItem.rightBarButtonItem = addBarButton
        
        //tableview
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.getColor(.mainColor)
        let nibName = UINib(nibName: StockScheduleTableViewCell.identifier, bundle: nibBundle)
        self.tableView.register(nibName, forCellReuseIdentifier: StockScheduleTableViewCell.identifier)
        self.tableView.tableFooterView = UIView(frame: .zero)
        
        //style
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor.getColor(.mainColor).cgColor
        
        self.tasks = localRealm.objects(UserStockSchedule.self)
        
        
        // calendar
        self.calendar.delegate = self
        self.calendar.dataSource = self
        
        calendar.headerHeight = 50
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 24)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.backgroundColor = UIColor.getColor(.mainColor)
        
    }
    
}


extension StockScheduleViewController : UITableViewDelegate,UITableViewDataSource {
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockScheduleTableViewCell.identifier, for: indexPath) as? StockScheduleTableViewCell else { return UITableViewCell() }
        
        self.startCalenderStart = calendar.currentPage.add(days:1)!
        self.endCalenderEnd = calendar.currentPage.add(months:1)!
        
        self.filteredDateTasks = tasks.filter("alarmDate BETWEEN %@", [startCalenderStart,endCalenderEnd]).sorted(byKeyPath: "alarmDate" , ascending: false )

        if filteredDateTasks.count == 0   {
            return UITableViewCell()
        }
        
        let row = filteredDateTasks[indexPath.row]
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "dd E"
        
        cell.titleLabel.text = row.titleName
        cell.alarmDateLabel.text = formatter.string(from: row.alarmDate)
        
        cell.alarmImage.image = row.isAlarm ? UIImage(systemName:  "bell.badge.fill" ) : UIImage(systemName: "bell.slash" )
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tasks == nil {
            return 0
        }
        
        self.startCalenderStart = calendar.currentPage.add(days:1)!
        self.endCalenderEnd = calendar.currentPage.add(months:1)!

        self.filteredDateTasks = tasks.filter("alarmDate BETWEEN %@", [startCalenderStart,endCalenderEnd])
        
        return filteredDateTasks.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StockScheduleDetailViewController") as! StockScheduleDetailViewController

        vc.memoData = filteredDateTasks[indexPath.row]
        
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        self.present(nav,animated: true, completion: nil)
        
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let row = tasks[indexPath.row]
            
            let StockSchduledetailController = StockScheduleDetailViewController()
            StockSchduledetailController.removeSendNofi(schedulUUID: row.scheduleUUID)
            
            try! localRealm.write{
                localRealm.delete(row)
                tableView.reloadData()
                calendar.reloadData()
            }
        }
    }
        
}

extension StockScheduleViewController :  FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let format = DateFormatter()
        format.dateFormat = "yyyyMMdd"
 
        return tasks.filter("calendarDate = %@" , format.string(from: date) ).count
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        tableView.reloadData()
        
    }
    
    
}


