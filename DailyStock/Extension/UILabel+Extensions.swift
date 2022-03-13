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
    
    func asFont(targetString: String) {
        
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.font, value: font, range: range)
        attributedText = attributedString
        
    }
}
