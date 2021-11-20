//
//  StockStudyDetailViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/20.
//

import UIKit
import RealmSwift


class StockStudyDetailViewController: UIViewController {

    
    let localRealm = try! Realm()
    var tasks : Results<UserStockStudy>!
    
    @IBOutlet var stockNameText: UITextField!
    @IBOutlet var updateDatePicker: UIDatePicker!
    @IBOutlet var salesText: UITextView!
    @IBOutlet var prosAndConsText: UITextView!
    @IBOutlet var memoText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "종목 분석"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        
    }
    
    
    @objc func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        let task = UserStockStudy(stockName: stockNameText.text!, updateDate: updateDatePicker.date, sales: salesText.text!, prosAndCons: prosAndConsText.text!, memo: memoText.text!, writeDate: Date())
        
        try! localRealm.write{
            localRealm.add(task)
        }
        
    }
    
    
    
}
