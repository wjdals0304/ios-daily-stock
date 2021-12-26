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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
    
        setUpStyle()


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
    
    @IBAction func dollerTypeClicked(_ sender: UIButton) {
        
        dollarButton.isSelected = wonButton.isSelected
        dollarButton.layer.backgroundColor =  UIColor(red: 0.176, green: 0.588, blue: 0.965, alpha: 1).cgColor
        
        dollarButton.tintColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        wonButton.isSelected = !wonButton.isSelected
        wonButton.layer.backgroundColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1).cgColor
        
        
        
    }
    
    @IBAction func wonTypeClicked(_ sender: UIButton) {
        
        wonButton.isSelected = wonButton.isSelected
        wonButton.layer.backgroundColor =  UIColor(red: 0.176, green: 0.588, blue: 0.965, alpha: 1).cgColor
        
        wonButton.tintColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        dollarButton.isSelected = !wonButton.isSelected
        dollarButton.layer.backgroundColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1).cgColor
        
    }
    
    func setUpStyle() {
        
        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1).cgColor
        
        
        [ stockNameLabel , stockAmountLabel , moneyTypeLabel, stockPriceLabel ].forEach {
            $0?.textColor = UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
            $0?.font = UIFont(name: "Roboto-Bold", size: 16)
        }
        
        [stockNameText , stockAmountText , stockPriceText  ].forEach {
            $0?.clipsToBounds = true
            $0?.layer.cornerRadius = 8
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor =  UIColor(red: 0.871, green: 0.878, blue: 0.913, alpha: 1).cgColor
        }
        
        saveUIButton.backgroundColor = UIColor(red: 0.975, green: 0.611, blue: 0.183, alpha: 1)
        
        saveUIButton.layer.cornerRadius = 10
        
        
        saveUIButton.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        saveUIButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 22)
        
        
        [wonButton,dollarButton].forEach {
            
            $0?.layer.backgroundColor =  UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1).cgColor
            $0?.layer.cornerRadius = 8
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor(red: 0.738, green: 0.753, blue: 0.817, alpha: 1).cgColor
            $0?.tintColor =  UIColor(red: 0.687, green: 0.711, blue: 0.808, alpha: 1)
            $0?.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 22 )
            
        }
        
        wonButton.tintColor =   UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        wonButton.layer.backgroundColor =  UIColor(red: 0.176, green: 0.588, blue: 0.965, alpha: 1).cgColor
        
    }

    
}
