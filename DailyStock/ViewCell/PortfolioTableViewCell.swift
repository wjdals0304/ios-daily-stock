//
//  PortfolioTableViewCell.swift
//  DailyStock
//
//  Created by 김정민 on 2021/12/22.
//

import UIKit

class PortfolioTableViewCell: UITableViewCell {

    @IBOutlet var stockNameLabel: UILabel!
    @IBOutlet var stockAmountNameLabel: UILabel!
    @IBOutlet var stockPriceNameLabel: UILabel!
    @IBOutlet var stockTotalAsseetsNameLabel: UILabel!
    
    @IBOutlet var percentLabel: UILabel!
    @IBOutlet var stockAmountLabel : UILabel!
    @IBOutlet var stockPriceLabel : UILabel!
    @IBOutlet var stocktotalAssetsLabel : UILabel!
    
    @IBOutlet var lineView: UIView!
    
    static let identifier = "PortfolioTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateUI(item : UserPortfolio?,stockPercentDic: Dictionary<String, String>) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        guard let cell = item else { return }
        
        let stockAmount = numberFormatter.string(from: NSNumber(value: cell.stockAmount))!
        let decimalPrice = numberFormatter.string(from: NSNumber(value: cell.stockPrice))!
        let stocktotalAssetsPrice =
        numberFormatter.string(from: NSNumber(value: cell.stockAmount * cell.stockPrice))!
        
        stockNameLabel.text = cell.stockName
        stockAmountLabel.text = "\(stockAmount)"
        stockPriceLabel.text = "\(decimalPrice)"
        stocktotalAssetsLabel.text = "\(stocktotalAssetsPrice)"
        percentLabel.text = stockPercentDic[cell.stockName]

    }
    
    func setUpStyle() {
        
        lineView?.layer.backgroundColor = UIColor(red: 0.89, green: 0.898, blue: 0.941, alpha: 1).cgColor
        
        stockNameLabel?.textColor = UIColor(red: 0.232, green: 0.244, blue: 0.292, alpha: 1)
        stockNameLabel?.font = UIFont(name: "Roboto-Regular", size: 24)
        
        [stockAmountNameLabel, stockPriceNameLabel, stockTotalAsseetsNameLabel].forEach {
            $0?.textColor = UIColor(red: 0.647, green: 0.671, blue: 0.765, alpha: 1)
            $0?.font = UIFont(name: "Roboto-Regular", size: 16)
        }
        
        percentLabel?.textColor = UIColor(red: 0.232, green: 0.244, blue: 0.292, alpha: 1)
        percentLabel?.font =  UIFont(name: "Roboto-Regular", size: 24)
        
        [stockAmountLabel, stockPriceLabel].forEach {
            $0?.textColor = UIColor(red: 0.416, green: 0.431, blue: 0.478, alpha: 1)
            $0?.font = UIFont(name: "Roboto-Regular", size: 18)
        }
        
        stocktotalAssetsLabel?.textColor = UIColor(red: 0.279, green: 0.284, blue: 0.304, alpha: 1)
        stocktotalAssetsLabel?.font = UIFont(name: "Roboto-Regular", size: 18)
        
    }
    
    
}
