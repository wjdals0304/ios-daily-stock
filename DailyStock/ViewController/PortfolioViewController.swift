//
//  PortfolioViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/12/20.
//

import UIKit
import Charts
import RealmSwift

class PortfolioViewController: UIViewController, ChartViewDelegate {

    @IBOutlet var pieChartView: PieChartView!

    @IBOutlet var totalAssetsNameLabel: UILabel!
    @IBOutlet var totalAssetsLabel: UILabel!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var viewInStack: UIView!
    
    
    var dollarViewModel = DollarViewModel()
    
    var tasks : Results<UserPortfolio>!
    var portofolioList : [UserPortfolio] = []
    let localRealm = try! Realm()
    var totalAssets = 0
    var dollar = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tableView.delegate = self
        tableView.dataSource = self
        tableViewHeight.constant = self.view.frame.height

        self.tableView.isScrollEnabled = false
        self.scrollView.bounces = false
        self.tableView.bounces = true

        let nibName = UINib(nibName: PortfolioTableViewCell.identifier, bundle: nibBundle)
        self.tableView.register(nibName, forCellReuseIdentifier: PortfolioTableViewCell.identifier)

        setUpBarButtonItem()
        
        self.tasks = localRealm.objects(UserPortfolio.self)
        self.portofolioList = Array(tasks)
        self.configureChartView(portofolioList: self.portofolioList)
        
        self.totalAssetsLabel.text = "\(totalAssets)"
        
        setUpStyle()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function)
//        self.portofolioList = Array(tasks)
//        self.configureChartView(portofolioList: self.portofolioList)
        
        self.tableView.reloadData()
    }

    func percentDouble(portofolio : UserPortfolio) -> Double {
        
        var total: Double = 0
        
        if portofolio.moneyType == "dollar" {
            total = Double(portofolio.stockPrice * self.dollar * portofolio.stockAmount ) / Double(totalAssets)
        } else {
            total = Double(portofolio.stockPrice * portofolio.stockAmount) / Double(totalAssets)
        }
        
        total = total * 100

        return  total
    }

    func configureChartView(portofolioList : [UserPortfolio]){
        
        dollarViewModel.getDollar {
            self.dollar = UserDefaults.standard.integer(forKey: "dollar")
        }
        
        // TODO: 달러, 원화 구분해서 계산
        print(portofolioList)
        for portofolio in portofolioList {
            if portofolio.moneyType == "dollar" {
                self.totalAssets += portofolio.stockPrice * self.dollar * portofolio.stockAmount
            } else {
                self.totalAssets += portofolio.stockPrice * portofolio.stockAmount
            }
        }
        
        self.pieChartView.delegate = self
        
        let entries = portofolioList.compactMap { [weak self] overview -> PieChartDataEntry? in

         guard let self = self else { return nil }
            
          return PieChartDataEntry(
            value: percentDouble(portofolio: overview)
            ,label: overview.stockName
            ,data: overview
          )
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: nil)
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.xValuePosition = .outsideSlice
        
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.2
        
        dataSet.colors = ChartColorTemplates.colorful()

        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        formatter.percentSymbol = "%"
        
        let l = pieChartView.legend

        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.xEntrySpace = 10
        l.yEntrySpace = 0
        self.pieChartView.drawHoleEnabled = false
        self.pieChartView.drawEntryLabelsEnabled = false
        self.pieChartView.notifyDataSetChanged()
        
        let pieChartData = PieChartData(dataSet:dataSet)
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        self.pieChartView.data = pieChartData
        
        self.pieChartView.spin(duration: 0.3, fromAngle: pieChartView.rotationAngle, toAngle: pieChartView.rotationAngle + 80)
    }
    
        
    
    func setUpBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(didAddButtonClicked(_:)))
    }


    @objc func didAddButtonClicked(_ sender : UIBarButtonItem) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortfolioDetailViewController") as! PortfolioDetailViewController
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav,animated: true,completion: nil)
        
    }
    
    func setUpStyle() {
        
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1).cgColor
        pieChartView.layer.cornerRadius = 20
        
        totalAssetsLabel.textColor =  UIColor(red: 0.232, green: 0.244, blue: 0.292, alpha: 1)
        totalAssetsLabel.font = UIFont(name: "Roboto-Bold", size: 28)
        
        totalAssetsNameLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        totalAssetsNameLabel.font = UIFont(name: "Roboto-Bold", size: 18)
        
        viewInStack.layer.cornerRadius = 40
        viewInStack.clipsToBounds = true


        viewInStack.layer.borderWidth = 20
        viewInStack.layer.borderColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1).cgColor
        
        
        viewInStack.backgroundColor = UIColor(red: 0.951, green: 0.953, blue: 0.971, alpha: 1)
        
        self.tableView.layer.cornerRadius = 20
        
    }


    
    
}

extension PortfolioViewController : UITableViewDataSource , UITableViewDelegate, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            tableView.isScrollEnabled = (self.scrollView.contentOffset.y >= 200)
        }
        
        if scrollView == self.tableView {
            self.tableView.isScrollEnabled = (tableView.contentOffset.y > 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PortfolioTableViewCell.identifier,for: indexPath) as? PortfolioTableViewCell else {
            return UITableViewCell()
        }
        
        let row = tasks[indexPath.row]
        
        
        cell.updateUI(item: row)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
}
