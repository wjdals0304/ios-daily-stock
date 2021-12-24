//
//  PortfolioViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/12/20.
//

import UIKit
import Charts
import RealmSwift

class PortfolioViewController: UIViewController, ChartViewDelegate, UIScrollViewDelegate {

    @IBOutlet var pieChartView: PieChartView!

    @IBOutlet var totalAssetsLabel: UILabel!
    @IBOutlet var tableView : UITableView!
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    @IBOutlet var viewStackView: UIView!
    
    
    var tasks : Results<UserPortfolio>!
    var portofolioList : [UserPortfolio] = []
    let localRealm = try! Realm()
    var totalAssets = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tableView.delegate = self
        tableView.dataSource = self

        print(self.viewStackView.frame.height + 200)
        tableViewHeight.constant = self.viewStackView.frame.height

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
        
        
    }
    

    func percentDouble(portofolio : UserPortfolio) -> Double {
        
        return Double(portofolio.stockPrice * portofolio.stockAmount) / Double(totalAssets) * 100
    }

    func configureChartView(portofolioList : [UserPortfolio]){
        
        // TODO: 달러, 원화 구분해서 계산
        for portofolio in portofolioList {
            self.totalAssets += portofolio.stockPrice * portofolio.stockAmount
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


    
    
}

extension PortfolioViewController : UITableViewDataSource , UITableViewDelegate{
    
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
