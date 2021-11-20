//
//  TradingDailyViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/19.
//

import UIKit
import RealmSwift

class TradingDailyViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButton: UIButton!
    
    let localRealm = try! Realm()
    
    var tasks : Results<UserTradingDaily>!
    var filteredDaily : Results<UserTradingDaily>!
    
    var fixedDailyCount : Int = 0
    var unfixedDailyCount : Int = 0
    var totalDailyCount : Int = 0
    
    
    var isFiltering : Bool {
    
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        
        return isActive && isSearchBarHasText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nibName = UINib(nibName: TradingDailyTableViewCell.identifier, bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: TradingDailyTableViewCell.identifier)
        
        self.tasks = localRealm.objects(UserTradingDaily.self)
        self.setUpSearchController()
        
        self.navigationItem.title = "매매일지"

        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    

    @IBAction func addClickedButton(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TradingDailyDetailViewController") as! TradingDailyDetailViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav,animated: true, completion: nil)
        
    }
    
    func setUpSearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.placeholder = "종목 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "매매일지"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
        
}


extension TradingDailyViewController : UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        return self.isFiltering ? filteredDaily.count : tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TradingDailyTableViewCell.identifier, for: indexPath) as? TradingDailyTableViewCell else { return UITableViewCell()}
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        if self.isFiltering {
            
            let filterRow = filteredDaily[indexPath.row]
    
            cell.stockNameLabel.text = filterRow.stockName
            cell.priceLabel.text = "\(filterRow.stockPrice)"
            cell.amountLabel.text = "\(filterRow.stockAmount)"
            cell.dateLabel.text =  formatter.string(from: filterRow.tradingDate)
            
        } else {
            
            let row = tasks[indexPath.row]

            cell.stockNameLabel.text = row.stockName
            cell.priceLabel.text = "\(row.stockPrice)"
            cell.amountLabel.text = "\(row.stockAmount)"
            cell.dateLabel.text = formatter.string(from: row.tradingDate)
            
        }

        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

}



extension TradingDailyViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        self.filteredDaily = self.localRealm.objects(UserTradingDaily.self).filter("stockName CONTAINS %@" ,text)
        
        self.tableView.reloadData()
    }
    
    
    
}
