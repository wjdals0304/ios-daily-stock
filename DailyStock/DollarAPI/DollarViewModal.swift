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
                return
            }
            
            print("baseprice ")
            print(dollar.first?.basePrice)

            UserDefaults.standard.set(dollar.first?.basePrice, forKey: "dollar")
            
                    
        }



    }
    
}
