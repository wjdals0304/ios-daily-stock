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
    
    case viewInStackPortFolio

    case lineView
    
    case orangeColor
    
    case whiteColor
    
    case activeMoneyTypeButtonColor
    
    case deactiveMoneyTypeButtonColor
    
    case imageBarColor
    
    case reuseViewBackgroundColor
    
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
        
        case .viewInStackPortFolio :
            return UIColor(red: 0.951, green: 0.953, blue: 0.971, alpha: 1)
            
        case .lineView:
            return UIColor(red: 0.89, green: 0.898, blue: 0.941, alpha: 1)
            
        case .orangeColor :
            return UIColor(red: 0.975, green: 0.611, blue: 0.183, alpha: 1)
            
            
        case .whiteColor :
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            
        case .activeMoneyTypeButtonColor :
            return UIColor(red: 0.176, green: 0.588, blue: 0.965, alpha: 1)
            
        case .imageBarColor:
            return UIColor(red: 0.891, green: 0.9, blue: 0.942, alpha: 1)
            
            
        case .reuseViewBackgroundColor:
            return UIColor(red: 0.951, green: 0.953, blue: 0.971, alpha: 1)
            
            
        case .deactiveMoneyTypeButtonColor :
            return UIColor(red: 0.738, green: 0.753, blue: 0.817, alpha: 1)
            
        }
        
    }
    
    
}
