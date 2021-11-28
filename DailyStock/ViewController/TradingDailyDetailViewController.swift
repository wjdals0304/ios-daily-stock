//
//  TradingDailyDetailViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/19.
//

import UIKit
import RealmSwift
import DropDown

class TradingDailyDetailViewController: UIViewController ,UIGestureRecognizerDelegate {

    let localRealm = try! Realm()
    var tasks : Results<UserTradingDaily>!
    
    var dailyData : UserTradingDaily?
    
    @IBOutlet var stockNameText: UITextField!
    @IBOutlet var tradingTypeButton: UIButton!

    @IBOutlet var stockAmountText: UITextField!
    @IBOutlet var stockPriceText: UITextField!
    @IBOutlet var tradingReasonText: UITextView!
    @IBOutlet var moneyTypeButton: UIButton!
    
    @IBOutlet var tradingDatePiker: UIDatePicker!

    @IBOutlet var stockNameLabel: UILabel!
    @IBOutlet var tradingTypeLabel: UILabel!
    @IBOutlet var tradingDateLabel: UILabel!
    @IBOutlet var stockAmountLabel: UILabel!
    @IBOutlet var stockPriceLabel: UILabel!
    @IBOutlet var tradingReasonLabel: UILabel!
    @IBOutlet var saveUIButton: UIButton!
    
    let dropDownTrading = DropDown()
    let dropDownMoney = DropDown()
    
    let tradingTypeArray = ["매수","매도"]
    let moneyTypeArray = ["원","달러"]
    
    var selectedBool : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        
        self.view.addGestureRecognizer(tapGesture)
        
        if dailyData != nil {
            self.stockNameText.text = dailyData?.stockName
            self.stockAmountText.text = "\(dailyData?.stockAmount ?? 0)"
            self.stockPriceText.text = "\(dailyData?.stockPrice ?? 0)"
            self.tradingReasonText.text = dailyData?.tradingReason
            self.tradingTypeButton.setTitle(dailyData?.tradingType, for: .normal)
            self.moneyTypeButton.setTitle(dailyData?.moneyType, for: .normal)
            self.tradingDatePiker.setDate(dailyData!.tradingDate, animated: true)
            
            self.selectedBool = true
        }
        
        setUpStyle()
    
    }
    
    func setUpStyle() {
        
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 0.914, green: 0.918, blue: 0.937, alpha: 1).cgColor
        
        stockNameLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        stockNameLabel.font = UIFont(name: "Roboto-Bold", size: 15)
        
        tradingTypeLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        tradingTypeLabel.font = UIFont(name: "Roboto-Bold", size: 15)
        
        tradingDateLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        tradingDateLabel.font = UIFont(name: "Roboto-Bold", size: 15)
        
        stockAmountLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        stockAmountLabel.font = UIFont(name: "Roboto-Bold", size: 15)
        
        stockPriceLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        stockPriceLabel.font = UIFont(name: "Roboto-Bold", size: 15)
        
        tradingReasonLabel.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
        tradingReasonLabel.font = UIFont(name: "Roboto-Bold", size: 15)
        
        stockNameText.clipsToBounds = true
        stockNameText.layer.cornerRadius = 8
        stockNameText.layer.borderWidth = 1
        stockNameText.layer.borderColor = UIColor(red: 0.871, green: 0.878, blue: 0.913, alpha: 1).cgColor
        
        stockAmountText.clipsToBounds = true
        stockAmountText.layer.cornerRadius = 8
        stockAmountText.layer.borderWidth = 1
        stockAmountText.layer.borderColor = UIColor(red: 0.871, green: 0.878, blue: 0.913, alpha: 1).cgColor
        
        tradingReasonText.clipsToBounds = true
        tradingReasonText.layer.cornerRadius = 8
        tradingReasonText.layer.borderWidth = 1
        tradingReasonText.layer.borderColor = UIColor(red: 0.871, green: 0.878, blue: 0.913, alpha: 1).cgColor
    
        // 셀렉트 박스
        dropDownTrading.anchorView = tradingTypeButton
        dropDownTrading.dataSource = tradingTypeArray
        dropDownTrading.selectionAction = {  [self] (index: Int , item: String) in
            self.tradingTypeButton.setTitle(tradingTypeArray[index], for: .normal)
        }
        
        dropDownMoney.anchorView = moneyTypeButton
        dropDownMoney.dataSource = moneyTypeArray
        dropDownMoney.selectionAction = {  [self] (index: Int , item: String) in
            self.moneyTypeButton.setTitle(moneyTypeArray[index], for: .normal)
        }
        dropDownMoney.width = 150
    
    }
    
    @objc func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func showTypeOptions(_ sender: Any) {
        dropDownTrading.show()
    }
    
    @IBAction func showMoneyOptions(_ sender: Any) {
        dropDownMoney.show()
    
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        guard self.stockNameText.text?.isEmpty == false
             ,self.tradingTypeButton.currentTitle?.isEmpty == false
             ,self.stockAmountText.text?.isEmpty == false
             ,self.stockPriceText.text?.isEmpty == false
             ,self.moneyTypeButton.currentTitle?.isEmpty == false
             ,self.tradingReasonText.text?.isEmpty == false
                
        else {
            
            let alert = UIAlertController(title: nil, message: "모든 항목을 확인해주세요.", preferredStyle: .alert )
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }

        
        let stockPrice = Int(stockPriceText.text!) ?? 0
        let stockAmount = Int(stockAmountText.text!) ?? 0
        

        if self.selectedBool == true {
            
            let task = localRealm.objects(UserTradingDaily.self).filter( "_id = %@",dailyData!._id).first
            
            try! localRealm.write {
                
                task?.stockName = stockNameText.text!
                task?.tradingType = tradingTypeButton.currentTitle!
                task?.tradingDate = tradingDatePiker.date
                task?.stockAmount = stockAmount
                task?.stockPrice = stockPrice
                task?.moneyType = moneyTypeButton.currentTitle!
                task?.tradingReason = tradingReasonText.text
                task?.writeDate = Date()
            
            }
            
        } else {
            
            let task = UserTradingDaily(stockName: stockNameText.text! , tradingType: tradingTypeButton.currentTitle!, tradingDate: tradingDatePiker.date, stockAmount: stockAmount , stockPrice: stockPrice , moneyType: moneyTypeButton.currentTitle! , tradingReason: tradingReasonText.text, writeDate: Date())
            
            try! localRealm.write {
                localRealm.add(task)
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
    


}
