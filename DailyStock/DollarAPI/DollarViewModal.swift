//
//  DollarViewModal.swift
//  DailyStock
//
//  Created by 김정민 on 2021/12/27.
//

import Foundation

class DollarViewModel {
    
    
    func getDollar(completion: @escaping() -> Void ) {
        
        DollarAPI.dollarPrice { dollar, error in
            
            guard let dollar = dollar else {
                return
            }

            UserDefaults.standard.set(dollar.first?.basePrice, forKey: "dollar")
            
            completion()
            
        }



    }
    
}
