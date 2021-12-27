//
//  Dollar.swift
//  DailyStock
//
//  Created by 김정민 on 2021/12/27.
//

import Foundation



// MARK: - Dollar
struct DollarElement : Codable {
    let basePrice: Int
}


typealias Dollar = [DollarElement]
