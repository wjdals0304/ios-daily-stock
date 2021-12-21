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

    let localRealm = try! Realm()
   @IBOutlet var pieChartView: PieChartView!
    var tasks : Results<UserPortfolio>!
    var portofolioList : [UserPortfolio] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpBarButtonItem()
        
        self.tasks = localRealm.objects(UserPortfolio.self)
        print("bb")

        self.portofolioList = Array(tasks)
        self.configureChartView(portofolioList: self.portofolioList)
        
    }
    
    func configureChartView(portofolioList : [UserPortfolio]){
        
        self.pieChartView.delegate = self
        let entries = portofolioList.compactMap { [weak self] overview -> PieChartDataEntry? in

         guard let self = self else { return nil }
           // value :
          // label : 파이차트 항목 이름
          // data :
          return PieChartDataEntry(
            value: Double(overview.stockAmount * overview.stockPrice)
            ,label: overview.stockName
            ,data: overview
          )
        }


        let dataSet = PieChartDataSet(entries: entries, label: "포토폴리오")
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black

        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart2Length = 0.3

        dataSet.colors = ChartColorTemplates.vordiplom()
          + ChartColorTemplates.joyful()
          + ChartColorTemplates.colorful()
          + ChartColorTemplates.liberty()
          + ChartColorTemplates.pastel()
          + ChartColorTemplates.material()


        self.pieChartView.data = PieChartData(dataSet:dataSet)
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
