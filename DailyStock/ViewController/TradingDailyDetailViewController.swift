//
//  TradingDailyDetailViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/19.
//

import UIKit
import RealmSwift

class TradingDailyDetailViewController: UIViewController ,UIGestureRecognizerDelegate {

    let localRealm = try! Realm()
    var tasks : Results<UserTradingDaily>!
    
    @IBOutlet var stockNameText: UITextField!
    @IBOutlet var tradingTypeButton: UIButton!
    
    @IBOutlet var stockAmountText: UITextField!
    @IBOutlet var stockPriceText: UITextField!
    @IBOutlet var tradingReasonText: UITextView!
    @IBOutlet var tradingDatePiker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "매매 일지"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))

        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        
        self.view.addGestureRecognizer(tapGesture)

    }
    
    @objc func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        
        let stockPrice = Int(stockPriceText.text!) ?? 0
        let stockAmount = Int(stockAmountText.text!) ?? 0
        
        let task = UserTradingDaily(stockName: stockNameText.text! , tradingType: "매도", tradingDate: tradingDatePiker.date, stockAmount: stockPrice , stockPrice: stockAmount , moneyType: "원화" , tradingReason: "Test", writeDate: Date())
        
        try! localRealm.write {
            localRealm.add(task)
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
    

}
