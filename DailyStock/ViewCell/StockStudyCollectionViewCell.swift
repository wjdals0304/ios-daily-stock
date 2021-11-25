//
//  StockStudyCollectionViewCell.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/17.
//

import UIKit

class StockStudyCollectionViewCell: UICollectionViewCell {

    
    static let identifier = "StockStudyCollectionViewCell"
    @IBOutlet var highlightIndicator: UIView!
    
    @IBOutlet var selectIndicator: UIImageView!
    @IBOutlet var stockNameLabel: UILabel!
    @IBOutlet var updateDateLabel: UILabel!
    
    override var isHighlighted: Bool {
        didSet {
            highlightIndicator.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highlightIndicator.isHidden = !isSelected
            selectIndicator.isHidden = !isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
