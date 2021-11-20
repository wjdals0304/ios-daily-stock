//
//  StockStudyCollectionViewCell.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/17.
//

import UIKit

class StockStudyCollectionViewCell: UICollectionViewCell {

    
    static let identifier = "StockStudyCollectionViewCell"
    
    @IBOutlet var stockNameLabel: UILabel!
    @IBOutlet var updateDateLabel: UILabel!
    @IBOutlet var memoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
