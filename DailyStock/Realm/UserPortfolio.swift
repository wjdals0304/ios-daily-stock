//
//  UserPortfolio.swift
//  DailyStock
//
//  Created by 김정민 on 2021/12/21.
//

import Foundation 
import RealmSwift

class UserPortfolio: Object {
    
    @Persisted var stockName: String
    @Persisted var stockAmount: Int
    @Persisted var moneyType: String
    @Persisted var stockPrice: Int

    @Persisted(primaryKey: true) var _id : ObjectId
    
    convenience init(stockName: String, stockAmount: Int, moneyType:String, stockPrice: Int) {
        
        self.init()
        
        self.stockName = stockName
        self.stockAmount = stockAmount
        self.moneyType = moneyType
        self.stockPrice = stockPrice
    }
    
}
