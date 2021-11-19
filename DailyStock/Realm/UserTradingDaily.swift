//
//  UserTradingDaily.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/18.
//

import Foundation
import RealmSwift


class UserTradingDaily: Object {
    
    @Persisted var stockName: String
    @Persisted var tradingType: String
    @Persisted var tradingDate : Date
    @Persisted var stockAmount : Int
    @Persisted var stockPrice : Int
    @Persisted var moneyType : String
    @Persisted var tradingReason : String 
    @Persisted var writeDate = Date()
    
    
    @Persisted(primaryKey: true) var _id : ObjectId
    
    
    convenience init(stockName: String, tradingType: String, tradingDate: Date, stockAmount : Int, stockPrice:Int, moneyType : String, tradingReason : String , writeDate: Date ) {
        
        self.init()
        
        self.stockName = stockName
        self.tradingType = tradingType
        self.stockAmount = stockAmount
        self.stockPrice = stockPrice
        self.tradingReason = tradingReason
        self.writeDate = writeDate
        
    
    }
    
    

    
}
