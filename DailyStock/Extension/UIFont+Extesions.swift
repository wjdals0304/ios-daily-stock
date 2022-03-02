//
//  UIFont+Extesions.swift
//  DailyStock
//
//  Created by 김정민 on 2022/03/02.
//

import UIKit

enum FontSize {
    
    case Bold_15
    
    case Bold_20

    case Bold_24
    
    case Bold_25

    case Bold_30
    
}


extension UIFont {
    
    static func getFont(_ size: FontSize) -> UIFont {
        
        switch size {
            
        case .Bold_15 :
            return UIFont(name: "Roboto-Bold", size: 15)!
        case .Bold_20 :
            return UIFont(name: "Roboto-Bold", size: 20)!
        case .Bold_24 :
            return UIFont(name: "Roboto-Bold", size: 24)!
        case .Bold_25 :
            return UIFont(name: "Roboto-Bold", size: 25)!
        case .Bold_30 :
            return UIFont(name: "Roboto-Bold", size: 30)!
            
        }
    
    }

}
