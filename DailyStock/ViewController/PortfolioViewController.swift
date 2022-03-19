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
    @IBOutlet var totalStackView: UIStackView!
    
    var dollarViewModel = DollarViewModel()
    var tasks : Results<UserPortfolio>!
    var portofolioList : [UserPortfolio] = []
    let localRealm = try! Realm()
    var totalAssets = 0
    var dollar = 0
    
    var stockPercentDic : [String:String] = [:]
    
    
    lazy var emptyView = EmptyDataView(frame:.zero , descText: "내가 가진 종목을 추가해서\n포트폴리오를 만들어보세요.", buttonText: "내 종목 추가하기")


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem.title = "포토폴리오"
        self.navigationItem.title = "포토폴리오"
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.navigationController?.navigationBar.barTintColor = UIColor.getColor(.mainColor)

        reloadPieChart()
        setUpTableView()
        setUpBarButtonItem()
        setUpStyle()
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        self.tableView.isScrollEnabled = false
        self.scrollView.bounces = false
        self.tableView.bounces = true

        let nibName = UINib(nibName: PortfolioTableViewCell.identifier, bundle: nibBundle)
        self.tableView.register(nibName, forCellReuseIdentifier: PortfolioTableViewCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,selector: #selector(reloadPieChart), name: NSNotification.Name("reloadPieChart") , object: nil)
                
        self.tableView.reloadData()
        tableViewHeightSize()
        checkEmptyDataView()
    }
    
    @objc func reloadPieChart() {
        
        tableViewHeightSize()

        self.totalAssets = 0
        self.tasks = localRealm.objects(UserPortfolio.self).sorted(byKeyPath: "percent", ascending: false)
        
        self.portofolioList = Array(tasks)
        self.configureChartView(portofolioList: self.portofolioList)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
            
        let totalAssetsDecimal = numberFormatter.string(from: NSNumber(value: totalAssets))!
        self.totalAssetsLabel.text = "₩\(totalAssetsDecimal)"
            
    }

    func tableViewHeightSize() {
        let taskCount = localRealm.objects(UserPortfolio.self).count

        if taskCount == 0 {
            tableViewHeight.constant = 0
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
            tableViewHeight.constant = CGFloat(taskCount) * 250 + 50
        }
    }
    
    func percentDouble(portofolio : UserPortfolio) -> Double {


        var total: Double = 0
        if portofolio.moneyType == "dollar" {
            total = Double(portofolio.stockPrice * self.dollar * portofolio.stockAmount ) / Double(totalAssets)
        } else {
            total = Double(portofolio.stockPrice * portofolio.stockAmount) / Double(totalAssets)
        }
        
        total = total * 100
        
        return total
    }

    func configureChartView(portofolioList : [UserPortfolio]){
        
        self.pieChartView.delegate = self
        self.dollarViewModel.getDollar()
        
        self.dollar = UserDefaults.standard.integer(forKey: "dollar")
        
        // [x] TODO: 달러, 원화 구분해서 계산
        for portofolio in portofolioList {
            if portofolio.moneyType == "dollar" {
                self.totalAssets += portofolio.stockPrice * self.dollar * portofolio.stockAmount
            } else {
                self.totalAssets += portofolio.stockPrice * portofolio.stockAmount
            }
        }
        
    
        var entries = portofolioList.compactMap { [weak self] overview -> PieChartDataEntry? in

         guard let self = self else { return nil }
          
            let stockPercent = Int(round(percentDouble(portofolio: overview)))
            self.stockPercentDic[overview.stockName] = "\(stockPercent)%"
            self.updateRealm(overview.stockName, stockPercent)
            
            
          return PieChartDataEntry(
             value: Double(stockPercent)
            ,label: overview.stockName + " - \( stockPercent )%"
            ,data: overview
          )
        }
        
        // MARK: 범례 퍼센트로 정렬
        entries = entries.sorted(by: { entry1, entry2 in
            entry1.y > entry2.y
        })
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black
        dataSet.valueTextColor = .black
        dataSet.xValuePosition = .outsideSlice
        dataSet.entryLabelColor = .black
        
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.2
        dataSet.colors = ChartColorTemplates.colorful() + ChartColorTemplates.material()
        + ChartColorTemplates.joyful() + ChartColorTemplates.liberty()


        let l = pieChartView.legend

        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.xEntrySpace = 10
        l.yEntrySpace = 0
        l.font = UIFont.systemFont(ofSize: 17)
        l.formSize = 17
        
        self.pieChartView.drawHoleEnabled = false
        self.pieChartView.drawEntryLabelsEnabled = false
        self.pieChartView.notifyDataSetChanged()
        
        let pieChartData = PieChartData(dataSet:dataSet)
        pieChartData.setValueTextColor(NSUIColor.clear)
        self.pieChartView.data = pieChartData
        
        self.pieChartView.spin(duration: 0.3, fromAngle: pieChartView.rotationAngle, toAngle: pieChartView.rotationAngle + 80)
    }
        
    func setUpBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(didAddButtonClicked(_:)))
    }
    
    // MARK: 로컬 디비 UserPortfolio 퍼센트 업데이트
    func updateRealm(_ stockName: String , _ percent: Int){
        
        let task = localRealm.objects(UserPortfolio.self).filter("stockName = %@",stockName).first
        
        try! localRealm.write {
            task?.percent = percent
        }
    }

    @objc func didAddButtonClicked(_ sender : UIBarButtonItem) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortfolioDetailViewController") as! PortfolioDetailViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func setUpStyle() {
        
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor.getColor(.mainColor).cgColor
        pieChartView.layer.cornerRadius = 20
        
        totalAssetsLabel.textColor =  UIColor.getColor(.numberColor)
        
        totalAssetsLabel.font = UIFont.getFont(.Bold_28)
        
        totalAssetsNameLabel.textColor = UIColor.getColor(.detailLabelColor)

        totalAssetsNameLabel.font = UIFont.getFont(.Bold_18)
        
        viewInStack.layer.cornerRadius = 40
        viewInStack.clipsToBounds = true

        viewInStack.layer.borderWidth = 20
        viewInStack.layer.borderColor = UIColor.getColor(.mainColor).cgColor
        viewInStack.backgroundColor =  UIColor.getColor(.viewInStackPortFolio)
    
        self.tableView.layer.cornerRadius = 20
        
    }
    
    
    func checkEmptyDataView() {
        
        let taskCount = localRealm.objects(UserPortfolio.self).count

        if taskCount == 0 {
            self.totalStackView.isHidden = true
            self.navigationItem.searchController?.searchBar.isHidden = true
            self.view.addSubview(self.emptyView)
            
            self.emptyView.snp.makeConstraints { make in
                make.centerY.equalTo(self.view.snp.centerY)
                make.centerX.equalTo(self.view.snp.centerX)
                make.width.equalTo(UIScreen.main.bounds.width - 52)
                make.height.equalTo(450)
            }
            
            self.emptyView.addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
            
        } else {
            self.totalStackView.isHidden = false
            
            self.emptyView.removeFromSuperview()
            
        }
        
    }
    
    @objc func addButtonClicked() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortfolioDetailViewController") as! PortfolioDetailViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
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
        cell.updateUI(item: row,stockPercentDic: self.stockPercentDic)
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 250
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editing = UIContextualAction(style: .normal, title: "편집") { (UIContextualAction , UIView , success: @escaping (Bool) -> Void) in

            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PortfolioDetailViewController") as! PortfolioDetailViewController
            
            vc.portofolioData = self.tasks[indexPath.row]
        
            self.navigationController?.pushViewController(vc, animated: true)
        }
    
        editing.backgroundColor = .systemBlue
        
    
        let delete = UIContextualAction(style: .normal, title: "삭제") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void ) in
            

            let row = self.tasks[indexPath.row]
            
            try! self.localRealm.write{
                
                self.localRealm.delete(row)
                tableView.reloadData()
            }
            self.reloadPieChart()
            self.checkEmptyDataView()
            
            
        }
        delete.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [delete,editing])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 50))

        let label = UILabel(frame: CGRect(x:20 , y: 10 , width: 150 , height : 40 ))

        label.text = "보유종목"
        label.font = UIFont.getFont(.Bold_18)
        view.addSubview(label)

        return view

    }
    
    
}

