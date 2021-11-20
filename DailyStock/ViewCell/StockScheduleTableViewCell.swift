//
//  StockScheduleTableViewCell.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/20.
//

import UIKit

class StockScheduleTableViewCell: UITableViewCell {

    @IBOutlet var alarmDateLabel: UILabel!
    @IBOutlet var memoLabel: UILabel!
    @IBOutlet var alarmImage: UIImageView!
    
    static let identifier = "StockScheduleTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
