//
//  PortfolioTableViewCell.swift
//  DailyStock
//
//  Created by 김정민 on 2021/12/22.
//

import UIKit

class PortfolioTableViewCell: UITableViewCell {

    @IBOutlet var stockNameLabel: UILabel!
    
    @IBOutlet var percentLabel: UILabel!
    @IBOutlet var stockAmountLabel : UILabel!
    @IBOutlet var stockPriceLabel : UILabel!
    @IBOutlet var stocktotalAssetsLabel : UILabel!
    
    static let identifier = "PortfolioTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func updateUI(item : UserPortfolio?) {
        
        guard let cell = item else { return }
        
        stockNameLabel.text = cell.stockName
        percentLabel.text = "0"
        stockAmountLabel.text = "\(cell.stockAmount)"
        stockPriceLabel.text = "\(cell.stockPrice)"
        stocktotalAssetsLabel.text = "\(cell.stockAmount * cell.stockPrice)"
        
        
    }
    
}
