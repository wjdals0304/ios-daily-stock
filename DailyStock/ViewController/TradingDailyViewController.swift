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
    var searchWord: String?
    
    
    var isFiltering : Bool {
    
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        
        return isActive && isSearchBarHasText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //style
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1).cgColor
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1)
        
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
        
        cell.stockNameLabel.textColor = UIColor.black
        cell.stockNameLabel.font =  UIFont(name: "Roboto-Bold", size: 50)
        
        cell.dateLabel.textColor = UIColor(red: 0.561, green: 0.565, blue: 0.576, alpha: 1)
        cell.dateLabel.font = UIFont(name: "Roboto-Bold", size: 20)
        
        cell.priceLabel.textColor = UIColor(red: 0.232, green: 0.244, blue: 0.292, alpha: 1)
        cell.priceLabel.font = UIFont(name: "Roboto-Bold", size: 24)
        
        cell.amountLabel.textColor =  UIColor(red: 0.232, green: 0.244, blue: 0.292, alpha: 1)
        cell.amountLabel.font = UIFont(name: "Roboto-Bold", size: 24)

        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1)
            .cgColor
        cell.layer.borderWidth = 8
        cell.layer.cornerRadius = 8
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
         
        
        if self.isFiltering {
 
            
            let filterRow = filteredDaily[indexPath.row]
            let decimalPrice = numberFormatter.string(from: NSNumber(value: filterRow.stockPrice))!
            
            cell.stockNameLabel.text = filterRow.stockName
            cell.stockNameLabel.KeywordBlue(searchWord ?? "")
            cell.priceLabel.text = "\(decimalPrice)"
            cell.amountLabel.text = "\(filterRow.stockAmount)주"
            cell.dateLabel.text =  formatter.string(from: filterRow.tradingDate)
            
        } else {
            
            let row = tasks[indexPath.row]
            let decimalPrice = numberFormatter.string(from: NSNumber(value: row.stockPrice))!

            cell.stockNameLabel.text = row.stockName
            cell.priceLabel.text = "\(decimalPrice)"
            cell.amountLabel.text = "\(row.stockAmount)주"
            cell.dateLabel.text = formatter.string(from: row.tradingDate)
            
        }

        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TradingDailyDetailViewController") as! TradingDailyDetailViewController
        
        vc.dailyData = self.isFiltering ? filteredDaily[indexPath.row] : tasks[indexPath.row]
        
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.modalPresentationStyle = .fullScreen
        
        self.present(nav,animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let row = tasks[indexPath.row]
            
            try! localRealm.write{
                localRealm.delete(row)
                tableView.reloadData()
            }
            
        }
        
        
    }
    
    
}

extension TradingDailyViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        

        self.searchWord = text
        self.filteredDaily = self.localRealm.objects(UserTradingDaily.self).filter("stockName CONTAINS %@" ,text)
        
        self.tableView.reloadData()
    }
    
    
    
}
