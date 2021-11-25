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
    
    var studyData : UserStockStudy?
    
    @IBOutlet var stockNameLabel: UILabel!
    @IBOutlet var updateLabel: UILabel!
    @IBOutlet var salesLabel : UILabel!
    @IBOutlet var prosAndConsLabel: UILabel!
    @IBOutlet var memoLabel: UILabel!
        
    @IBOutlet var viewInScroll: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "종목 분석"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        
        if studyData != nil {
            self.stockNameText.text = studyData?.stockName
            self.updateDatePicker.date = studyData!.updateDate
            self.salesText.text = studyData?.sales
            self.prosAndConsText.text = studyData?.prosAndCons
            self.memoText.text = studyData?.memo
        }
        
        updateDatePicker.locale = Locale(identifier: "ko-KR")

        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 0.914, green: 0.918, blue: 0.937, alpha: 1).cgColor
        
        viewInScroll.backgroundColor = .white
        viewInScroll.layer.backgroundColor = UIColor(red: 0.914, green: 0.918, blue: 0.937, alpha: 1).cgColor
        
        stockNameLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        stockNameLabel.font = UIFont(name: "Roboto-Bold", size: 20)

        updateLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        updateLabel.font = UIFont(name: "Roboto-Bold", size: 20)

        salesLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        salesLabel.font = UIFont(name: "Roboto-Bold", size: 20)

        prosAndConsLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        prosAndConsLabel.font = UIFont(name: "Roboto-Bold", size: 20)

        memoLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        memoLabel.font = UIFont(name: "Roboto-Bold", size: 20)

        stockNameText.clipsToBounds = true
        stockNameText.layer.cornerRadius = 8
        stockNameText.layer.borderWidth = 1
        stockNameText.layer.borderColor = UIColor(red: 0.871, green: 0.878, blue: 0.913, alpha: 1).cgColor

        salesText.clipsToBounds = true
        salesText.layer.cornerRadius = 8
        salesText.layer.borderWidth = 1
        salesText.layer.borderColor = UIColor(red: 0.871, green: 0.878, blue: 0.913, alpha: 1).cgColor

        prosAndConsText.clipsToBounds = true
        prosAndConsText.layer.cornerRadius = 8
        prosAndConsText.layer.borderWidth = 1
        prosAndConsText.layer.borderColor = UIColor(red: 0.871, green: 0.878, blue: 0.913, alpha: 1).cgColor

        memoText.clipsToBounds = true
        memoText.layer.cornerRadius = 8
        memoText.layer.borderWidth = 1
        memoText.layer.borderColor = UIColor(red: 0.871, green: 0.878, blue: 0.913, alpha: 1).cgColor
    }
    
    
    @objc func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        let task = UserStockStudy(stockName: stockNameText.text!, updateDate: updateDatePicker.date, sales: salesText.text!, prosAndCons: prosAndConsText.text!, memo: memoText.text!, writeDate: Date())
        
        try! localRealm.write{
            localRealm.add(task)
        }
     
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
