//
//  TradingDailyViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/19.
//

import UIKit
import RealmSwift
import Firebase
import SnapKit

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
    
    lazy var emptyView = EmptyDataView(frame:.zero , descText: "하루하루 매매일지를 기록해보세요", buttonText: "매매일지 기록하기")

    var isFiltering : Bool {
    
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        
        return isActive && isSearchBarHasText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        self.navigationController?.navigationBar.barTintColor = UIColor.getColor(.mainColor)

        self.tasks = localRealm.objects(UserTradingDaily.self)
        self.setUpSearchController()
    
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        setup()
    
        //crash test
        //        let button = UIButton(type: .roundedRect)
        //           button.frame = CGRect(x: 20, y: 200, width: 100, height: 30)
        //           button.setTitle("Test Crash", for: [])
        //           button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        //           view.addSubview(button)
        
    }
    
    //    @IBAction func crashButtonTapped(_ sender: AnyObject) {
    //        let numbers = [0]
    //        let _ = numbers[1]
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        super.viewWillAppear(animated)
        tableView.reloadData()
        checkEmptyDataView()
    }
    
    func checkEmptyDataView() {
        
        let taskCount = localRealm.objects(UserTradingDaily.self).count

        if taskCount == 0 {
            self.tableView.isHidden = true
            self.addButton.isHidden = true
            self.navigationItem.searchController?.searchBar.isHidden = true
            self.view.addSubview(self.emptyView)
            
            self.emptyView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(150)
                make.bottom.equalTo(view.safeAreaLayoutGuide).inset(82)
                make.leading.equalToSuperview().offset(26)
                make.width.equalTo(UIScreen.main.bounds.width - 52)
            }
            
            self.emptyView.addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
            
        } else {
            self.tableView.isHidden = false
            self.addButton.isHidden = false
            self.navigationItem.searchController?.searchBar.isHidden = false

            self.emptyView.removeFromSuperview()
            
        }
        
    }
    
    
    @IBAction func addClickedButton(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TradingDailyDetailViewController") as! TradingDailyDetailViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addButtonClicked() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TradingDailyDetailViewController") as! TradingDailyDetailViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setUpSearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.placeholder = "종목 검색"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "매매일지"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setup() {
        
        // view
        view.layer.backgroundColor = UIColor.getColor(.mainColor).cgColor
        
        // addButton
        addButton.setTitle("", for: .normal)

        
        // tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.getColor(.mainColor)
        
        let nibName = UINib(nibName: TradingDailyTableViewCell.identifier, bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: TradingDailyTableViewCell.identifier)
        self.tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
}


extension TradingDailyViewController : UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tasksCount =  tasks == nil ? 0 : tasks.count
         
        return self.isFiltering ? filteredDaily.count : tasksCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TradingDailyTableViewCell.identifier, for: indexPath) as? TradingDailyTableViewCell else { return UITableViewCell()}
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
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
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let row = tasks[indexPath.row]
            
            try! localRealm.write{
                localRealm.delete(row)
                tableView.reloadData()
                checkEmptyDataView()
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
