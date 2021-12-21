//
//  PortfolioDetailViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/12/20.
//

import UIKit
import RealmSwift

class PortfolioDetailViewController: UIViewController {
    
    let localRealm = try! Realm()
    
    @IBOutlet var stockNameText: UITextField!
    @IBOutlet var stockAmountText : UITextField!
    @IBOutlet var wonButton : UIButton!
    @IBOutlet var dollarButton : UIButton!
    @IBOutlet var stockPriceText : UITextField!
    @IBOutlet var saveUIButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
    }
    
    @objc func closeButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        // TODO: 달러/원화 선택 로직 , 편집 구현
        
        guard self.stockNameText.text?.isEmpty == false
                , self.stockAmountText.text?.isEmpty == false
                , self.stockPriceText.text?.isEmpty == false
        else { return }
            
        
            let stockAmount = Int(stockAmountText.text!) ?? 0
            let stockPrice = Int(stockPriceText.text!) ?? 0
            
            let task = UserPortfolio(stockName: stockNameText.text!, stockAmount: stockAmount, moneyType: "won", stockPrice: stockPrice)
            
            
            try! localRealm.write {
                localRealm.add(task)
            }
            
       
       self.dismiss(animated: true, completion: nil)

        
    }

    
}
