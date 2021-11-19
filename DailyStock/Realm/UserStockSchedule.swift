//
//  UserStockSchedule.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/18.
//

import Foundation
import RealmSwift



class UserStockSchedule: Object {
    
    @Persisted var stockName : String
    @Persisted var updateDate : Date
    @Persisted var alarmDate : Date
    @Persisted var isAlarm : Bool
    @Persisted var memo : String
    @Persisted var writeDate = Date()

    
    
    @Persisted(primaryKey: true) var _id : ObjectId

    
    convenience init(stockName: String, updateDate: Date , alarmDate: Date, memo: String, writeDate : Date ) {
        
        self.init()
        
        self.stockName = stockName
        self.updateDate = updateDate
        self.alarmDate = alarmDate
        self.memo = memo
        self.isAlarm = false
        self.writeDate = writeDate
        
        
    }
    
    

}
