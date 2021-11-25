//
//  Date+Extensions.swift
//  DailyStock
//
//  Created by 김정민 on 2021/11/22.
//

import Foundation


extension Date {

    /// Returns a Date with the specified amount of components added to the one it is called with
    func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        let components = DateComponents(year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
        return Calendar.current.date(byAdding: components, to: self)
    }

    /// Returns a Date with the specified amount of components subtracted from the one it is called with
    func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date? {
        return add(years: -years, months: -months, days: -days, hours: -hours, minutes: -minutes, seconds: -seconds)
    }
    
    
       func toString( dateFormat format: String ) -> Date {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = format
           dateFormatter.timeZone = TimeZone.autoupdatingCurrent
           dateFormatter.locale = Locale.current
           return dateFormatter.date(from: dateFormatter.string(from: self)
           )!
       }
//
//        func toDate( dateFormat format: String) -> Date {
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = format
//            dateFormatter.timeZone = TimeZone.autoupdatingCurrent
//            dateFormatter.locale = Locale.current
//            return dateFormatter.date(from: self)!
//        }
//
//       
//       func toStringKST( dateFormat format: String ) -> String {
//           return self.toString(dateFormat: format)
//       }
//
//      func toDateKST( dateFormat format: String ) -> Date {
//        return self.toDate(dateFormat: format)
//      }
    
    
       func toStringUTC( dateFormat format: String ) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = format
           dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
           return dateFormatter.string(from: self)
       }
    

}
