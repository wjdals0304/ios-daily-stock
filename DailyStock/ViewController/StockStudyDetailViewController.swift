//
//  StockStudyDetailViewController.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/20.
//

import UIKit
import RealmSwift


class StockStudyDetailViewController: UIViewController,UIGestureRecognizerDelegate {

    
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
    
    var selectedBool : Bool = false
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.getColor(.mainColor)
        

        if studyData != nil {
            self.stockNameText.text = studyData?.stockName
            self.updateDatePicker.date = studyData!.updateDate
            self.salesText.text = studyData?.sales
            self.prosAndConsText.text = studyData?.prosAndCons
            self.memoText.text = studyData?.memo
            
            self.selectedBool = true
        }
        
        setup()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
        tapGesture.delegate = self
        
        self.view.addGestureRecognizer(tapGesture)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    
    func setup() {
        
        updateDatePicker.locale = Locale(identifier: "ko-KR")

        view.backgroundColor = .white
        view.layer.backgroundColor = UIColor.getColor(.mainColor).cgColor
        
        viewInScroll.backgroundColor = .white
        viewInScroll.layer.backgroundColor = UIColor.getColor(.mainColor).cgColor
        
        navigationItem.title = "종목 분석"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        
        [
            stockNameLabel,
            updateLabel,
            salesLabel,
            prosAndConsLabel,
            memoLabel
        ].forEach { label in
            label?.textColor = UIColor.getColor(.detailLabelColor)
            label?.font = UIFont.getFont(.Bold_20)
        }
        
        [
            stockNameText,
            salesText,
            prosAndConsText,
            memoText
        ].forEach { text in
            text?.clipsToBounds = true
            text?.layer.cornerRadius = 8
            text?.layer.borderWidth = 1
            text?.layer.borderColor = UIColor.getColor(.detailTextColor).cgColor
        }
    }
    
    @objc func closeButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }

    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        guard self.stockNameText.text?.isEmpty == false
        else {
            let alert = UIAlertController(title: nil, message: "종목이름을 입력해주세요.", preferredStyle: .alert )
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        if self.selectedBool == true {
            
            let task = localRealm.objects(UserStockStudy.self).filter("_id = %@",studyData!._id).first
            
            try! localRealm.write{
                
                task?.stockName = stockNameText.text!
                task?.updateDate = updateDatePicker.date
                task?.sales = salesText.text!
                task?.prosAndCons = prosAndConsText.text!
                task?.memo = memoText.text!
                task?.writeDate = Date()
            }
            
        } else {
            
            let task = UserStockStudy(stockName: stockNameText.text!, updateDate: updateDatePicker.date, sales: salesText.text!, prosAndCons: prosAndConsText.text!, memo: memoText.text!, writeDate: Date())
            
            try! localRealm.write{
                localRealm.add(task)
            }
            
        }
        
        self.navigationController?.popViewController(animated: true)
    }

    
}
