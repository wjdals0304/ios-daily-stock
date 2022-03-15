//
//  DollarViewModal.swift
//  DailyStock
//
//  Created by 김정민 on 2021/12/27.
//

import Foundation

class DollarViewModel {
    
    
    func getDollar() {
        
        DollarAPI.dollarPrice { dollar, error in
            
            guard let dollar = dollar else {
                UserDefaults.standard.set(1200, forKey: "dollar")
                return
            }
            UserDefaults.standard.set(dollar.first?.basePrice, forKey: "dollar")
        }



    }
    
}
