//
//  UIFont+Extesions.swift
//  DailyStock
//
//  Created by 김정민 on 2022/03/02.
//

import UIKit

enum FontSize {
    
    case Bold_15
    
    case Bold_16
    
    case Bold_18
    
    case Bold_20

    case Bold_22
    
    case Bold_24
    
    case Bold_25
    
    case Bold_28

    case Bold_30
    
    case regular_18

    case regular_20
    
    case regular_24
    
    
}


extension UIFont {
    
    static func getFont(_ size: FontSize) -> UIFont {
        
        switch size {
            
        
            
            
        case .Bold_15 :
            return UIFont(name: "Roboto-Bold", size: 15)!
        case .Bold_16 :
            return UIFont(name: "Roboto-Bold", size: 16)!
        case .Bold_18 :
            return UIFont(name: "Roboto-Bold", size: 18)!
        case .Bold_20 :
            return UIFont(name: "Roboto-Bold", size: 20)!
        case .Bold_22:
            return UIFont(name: "Roboto-Bold", size: 22)!
        case .Bold_24 :
            return UIFont(name: "Roboto-Bold", size: 24)!
        case .Bold_25 :
            return UIFont(name: "Roboto-Bold", size: 25)!
        case .Bold_28:
            return UIFont(name: "Roboto-Bold", size: 28)!
        case .Bold_30 :
            return UIFont(name: "Roboto-Bold", size: 30)!
        case .regular_18:
            return UIFont(name: "Roboto-Regular", size: 18)!
        case .regular_20:
            return UIFont(name: "Roboto-Regular", size: 20)!
        case .regular_24:
            return UIFont(name: "Roboto-Regular", size: 24)!

        }
    
    }

}
