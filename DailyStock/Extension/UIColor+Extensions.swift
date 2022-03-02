//
//  UIColor+Extensions.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/26.
//

import UIKit

enum Color {
    
    //main color
    case mainColor
    
    // date color
    case dateColor
    
    // number color
    case numberColor
    
    case detailLabelColor
    
    case detailTextColor
}


extension UIColor {
    
    static func getColor(_ name: Color) -> UIColor {
    
        switch name {
        
        case .mainColor :
            return UIColor(red: 0.914, green: 0.916, blue: 0.938, alpha: 1)
            
        case .dateColor :
            return UIColor(red: 0.561, green: 0.565, blue: 0.576, alpha: 1)
            
        case .numberColor :
            return UIColor(red: 0.232, green: 0.244, blue: 0.292, alpha: 1)
            
        case .detailLabelColor:
            return UIColor(red: 0.417, green: 0.43, blue: 0.479, alpha: 1)
            
        case .detailTextColor :
            return UIColor(red: 0.871, green: 0.878, blue: 0.913, alpha: 1)
            
            
        }
        
    }
    
    
}
