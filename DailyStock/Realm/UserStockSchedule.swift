//
//  UserStockSchedule.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/18.
//

import Foundation
import RealmSwift



class UserStockSchedule: Object {
    
    @Persisted var titleName : String
    @Persisted var alarmDate : Date
    @Persisted var isAlarm : Bool
    @Persisted var memo : String
    @Persisted var writeDate = Date()

    
    
    @Persisted(primaryKey: true) var _id : ObjectId

    
    convenience init(titleName: String, isAlarm: Bool , alarmDate: Date, memo: String, writeDate : Date ) {
        
        self.init()
        
        self.titleName = titleName
        self.alarmDate = alarmDate
        self.memo = memo
        self.isAlarm = isAlarm
        self.writeDate = writeDate
        
    }
    
    

}
