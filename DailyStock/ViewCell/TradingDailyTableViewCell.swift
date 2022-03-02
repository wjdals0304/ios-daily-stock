//
//  TradingDailyTableViewCell.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/17.
//

import UIKit

class TradingDailyTableViewCell: UITableViewCell {

    static let identifier = "TradingDailyTableViewCell"
    
    @IBOutlet var stockNameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        
        stockNameLabel.textColor = UIColor.black
        stockNameLabel.font = UIFont.getFont(.Bold_30)
        
        dateLabel.textColor = UIColor.getColor(.dateColor)
        dateLabel.font = UIFont.getFont(.Bold_20)
        
        priceLabel.textColor = UIColor.getColor(.numberColor)
        priceLabel.font = UIFont.getFont(.Bold_24)
        
        amountLabel.textColor = UIColor.getColor(.numberColor)
        amountLabel.font = UIFont.getFont(.Bold_24)
        
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.getColor(.mainColor).cgColor
        self.layer.borderWidth = 8
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        
    }
    
    
    
    
}
