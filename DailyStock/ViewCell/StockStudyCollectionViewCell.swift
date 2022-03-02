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
    
    override func layoutSubviews() {
        
        self.layer.borderColor = UIColor.getColor(.mainColor).cgColor
        self.backgroundColor = .white
        self.layer.borderWidth = 10
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        stockNameLabel.textColor = UIColor.black
        stockNameLabel.font = UIFont.getFont(.Bold_25)
        
        updateDateLabel.textColor = UIColor.getColor(.dateColor)
        updateDateLabel.font = UIFont.getFont(.Bold_15)
        
        
        
    }
    
}
