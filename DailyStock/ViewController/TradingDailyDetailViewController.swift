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
    @IBOutlet var tradingDatePiker: UIDatePicker!
    @IBOutlet var moneyTypeButton: UIButton!
    
    let dropDownTrading = DropDown()
    let dropDownMoney = DropDown()
    
    let tradingTypeArray = ["매수","매도"]
    let moneyTypeArray = ["원","달러"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "매매 일지"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        
        self.view.addGestureRecognizer(tapGesture)
        
        
        if dailyData != nil {
            self.stockNameText.text = dailyData?.stockName
            self.stockAmountText.text = "\(dailyData?.stockAmount ?? 0)"
            self.stockPriceText.text = "\(dailyData?.stockPrice ?? 0)"
            self.tradingReasonText.text = dailyData?.tradingReason
            
        }
        
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
        
        
        let stockPrice = Int(stockPriceText.text!) ?? 0
        let stockAmount = Int(stockAmountText.text!) ?? 0
        
        let task = UserTradingDaily(stockName: stockNameText.text! , tradingType: tradingTypeButton.currentTitle!, tradingDate: tradingDatePiker.date, stockAmount: stockPrice , stockPrice: stockAmount , moneyType: moneyTypeButton.currentTitle!, tradingReason: tradingReasonText.text, writeDate: Date())
        
        try! localRealm.write {
            localRealm.add(task)
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
    

}
