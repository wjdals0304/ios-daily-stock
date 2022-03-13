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
    
    @IBOutlet var stackView: UIStackView!
    static let identifier = "PortfolioTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the slelected state
    }

    override func layoutSubviews() {
        

        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
        stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -40).isActive = true

        
        lineView?.layer.backgroundColor = UIColor.getColor(.lineView).cgColor
        stockNameLabel?.textColor = UIColor.getColor(.numberColor)
        stockNameLabel?.font = UIFont.getFont(.Bold_24)
        
        [stockAmountNameLabel, stockPriceNameLabel, stockTotalAsseetsNameLabel].forEach {
            $0?.textColor = UIColor.getColor(.numberColor)
            $0?.font = UIFont.getFont(.regular_20)
        }
        
        percentLabel?.textColor = UIColor.getColor(.numberColor)
        percentLabel?.font =  UIFont.getFont(.regular_24)
        
        [stockAmountLabel, stockPriceLabel].forEach {
            $0?.textColor = UIColor.getColor(.numberColor)
            $0?.font = UIFont.getFont(.regular_20)
        }
            
        stocktotalAssetsLabel?.font = UIFont.getFont(.Bold_18)
        stocktotalAssetsLabel.textColor = UIColor.getColor(.orangeColor)
        
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
        stockPriceLabel.text = "₩\(decimalPrice)"
        stocktotalAssetsLabel.text = "₩\(stocktotalAssetsPrice)"
        percentLabel.text = stockPercentDic[cell.stockName]

    }
    
  
    
}
