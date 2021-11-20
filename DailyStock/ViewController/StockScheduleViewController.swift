//
//  StockScheduleViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/20.
//

import UIKit
import RealmSwift


class StockScheduleViewController: UIViewController {

    let localRealm = try! Realm()
    
    var tasks : Results<UserStockSchedule>!

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nibName = UINib(nibName: StockScheduleTableViewCell.identifier, bundle: nibBundle)
        
        self.tableView.register(nibName, forCellReuseIdentifier: StockScheduleTableViewCell.identifier)
        
        self.tasks = localRealm.objects(UserStockSchedule.self)
        
    }
    
    
    
}


extension StockScheduleViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockScheduleTableViewCell.identifier, for: indexPath) as? StockScheduleTableViewCell else { return UITableViewCell() }
        
        let row = tasks[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd EEEEE"
        
        
        cell.memoLabel.text = row.memo
        cell.alarmDateLabel.text = formatter.string(from: row.alarmDate)
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
}
