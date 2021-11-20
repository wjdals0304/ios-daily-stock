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
    
}
