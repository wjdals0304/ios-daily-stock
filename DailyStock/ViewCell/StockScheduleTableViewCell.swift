//
//  StockScheduleTableViewCell.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/20.
//

import UIKit

class StockScheduleTableViewCell: UITableViewCell {

    @IBOutlet var alarmDateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var alarmImage: UIImageView!
    
    static let identifier = "StockScheduleTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        
        self.layer.borderColor = UIColor.getColor(.mainColor).cgColor
        self.backgroundColor = .white
        self.layer.borderWidth = 10
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    
}
