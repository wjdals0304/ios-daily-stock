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
    
    @IBOutlet var stockNameLabel: UILabel!
    @IBOutlet var stockAmountLabel: UILabel!
    @IBOutlet var moneyTypeLabel: UILabel!
    @IBOutlet var stockPriceLabel: UILabel!
    
    var portofolioData : UserPortfolio?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
    
        setUpStyle()
        
        if portofolioData != nil {
            
            self.stockNameText.text = portofolioData?.stockName
        
            self.stockAmountText.text = "\(String(describing: portofolioData!.stockAmount))"
            self.stockPriceText.text = "\(String(describing: portofolioData!.stockPrice))"
            
            
            if portofolioData?.moneyType == "won" {
                wonButton.layer.backgroundColor =  UIColor.getColor(.activeMoneyTypeButtonColor).cgColor
                wonButton.isSelected = true
            } else {
                dollarButton.layer.backgroundColor = UIColor.getColor(.activeMoneyTypeButtonColor).cgColor
                dollarButton.isSelected = true
            }
        }
        
    }
    
    @objc func closeButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        // TODO: 달러/원화 선택 로직 , 편집 구현
        
        guard self.stockNameText.text?.isEmpty == false
                , self.stockAmountText.text?.isEmpty == false
                , self.stockPriceText.text?.isEmpty == false
        else {
            
            let alert = UIAlertController(title: nil, message: "모든 항목을 확인해주세요.", preferredStyle: .alert )
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let stockName = stockNameText.text else {
            return
        }
        let stockAmount = Int(stockAmountText.text!) ?? 0
        let stockPrice = Int(stockPriceText.text!) ?? 0
        let moneyType = self.dollarButton.isSelected ? "dollar" : "won"
        
        let task = localRealm.objects(UserPortfolio.self).filter("stockName = %@",stockName).first
        
        if task != nil {
            
            try! localRealm.write {
                task?.stockAmount = stockAmount
                task?.moneyType = moneyType
                task?.stockPrice = stockPrice
            }
            
        } else {
            
            let task = UserPortfolio(stockName: stockName, stockAmount: stockAmount, moneyType: moneyType, stockPrice: stockPrice ,percent: 0)
            
            try! localRealm.write {
                localRealm.add(task)
            }
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("reloadPieChart"), object: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func dollerTypeClicked(_ sender: UIButton) {
        
        dollarButton.isSelected = !wonButton.isSelected
        dollarButton.layer.backgroundColor =  UIColor.getColor(.activeMoneyTypeButtonColor).cgColor
        
        dollarButton.tintColor =  UIColor.getColor(.whiteColor)
        
        wonButton.isSelected = !dollarButton.isSelected
        wonButton.layer.backgroundColor = UIColor.getColor(.mainColor).cgColor
                    
    }
    
    @IBAction func wonTypeClicked(_ sender: UIButton) {
        
        wonButton.isSelected = !dollarButton.isSelected
        wonButton.layer.backgroundColor =  UIColor.getColor(.activeMoneyTypeButtonColor).cgColor
        
        wonButton.tintColor =  UIColor.getColor(.whiteColor)
        dollarButton.isSelected = !wonButton.isSelected
        dollarButton.layer.backgroundColor = UIColor.getColor(.mainColor).cgColor
        
 
        
    }
    
    func setUpStyle() {
        
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor.getColor(.mainColor).cgColor
        
        
        [ stockNameLabel , stockAmountLabel , moneyTypeLabel, stockPriceLabel ].forEach {
            $0?.textColor = UIColor.getColor(.detailLabelColor)

            $0?.font = UIFont.getFont(.Bold_16)
        }
        
        [stockNameText , stockAmountText , stockPriceText  ].forEach {
            $0?.clipsToBounds = true
            $0?.layer.cornerRadius = 8
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor =  UIColor.getColor(.detailTextColor).cgColor
        }
        
        saveUIButton.backgroundColor = UIColor.getColor(.orangeColor)
        saveUIButton.layer.cornerRadius = 10
        
        
        saveUIButton.tintColor = UIColor.getColor(.whiteColor)
        saveUIButton.titleLabel?.font = UIFont.getFont(.Bold_22)
        
        
        [wonButton,dollarButton].forEach {
            
            $0?.layer.backgroundColor =  UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1).cgColor
            $0?.layer.cornerRadius = 8
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor(red: 0.738, green: 0.753, blue: 0.817, alpha: 1).cgColor
            $0?.tintColor =  UIColor(red: 0.687, green: 0.711, blue: 0.808, alpha: 1)
            $0?.titleLabel?.font = UIFont.getFont(.Bold_22)
            
        }
        
        wonButton.tintColor =   UIColor.getColor(.whiteColor)
        wonButton.layer.backgroundColor =  UIColor.getColor(.activeMoneyTypeButtonColor).cgColor
        
    }

    
}
