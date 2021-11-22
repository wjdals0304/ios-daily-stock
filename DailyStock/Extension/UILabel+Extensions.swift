//
//  UILabel+Extensions.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/21.
//

import Foundation
import UIKit


extension UILabel {
  
    func KeywordBlue(_ keyword: String) {
      
      let fullText = self.text ?? ""
      
      let range = (fullText as NSString).range(of: keyword)
      
      let textColor = UIColor.systemBlue
      
      let attributedString = NSMutableAttributedString(string: fullText)
      
      attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
      
        
      self.attributedText = attributedString
    }
}
