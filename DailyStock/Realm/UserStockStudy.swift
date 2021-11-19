//
//  UserStockStudy.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/18.
//

import Foundation
import RealmSwift


class UserStockStudy: Object {
    
    @Persisted(primaryKey: true) var stockName : String
    @Persisted var writeDate = Date()
    @Persisted var sales : String
    @Persisted var prosAndCons : String
    @Persisted var memo : String
    
    
    convenience init(stockName: String, sales: String , prosAndCons: String, memo: String, writeDate: Date ) {
        
        self.init()
        
        self.stockName = stockName
        self.sales = sales
        self.prosAndCons = prosAndCons
        self.writeDate = writeDate
        
    
    }
    
    

}
