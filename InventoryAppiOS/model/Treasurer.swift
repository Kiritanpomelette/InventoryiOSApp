//
//  Treasurer.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/25.
//

import Foundation

struct Treasurer {
    let id: Int
    let productId: Int
    let managerId: Int
    let modifyDate: Date
    let count: Int
}

extension [Treasurer] {
    func getCurrentCount() -> Int{
        var sum = 0
        self.forEach { treasurer in
            sum += treasurer.count
        }
        return sum
    }
    func getTodayCount() -> Int {
        var sum = 0
        let today = Date()
        for treasurer in self {
            if !Calendar.current.isDate(
                today,
                equalTo: treasurer.modifyDate,
                toGranularity: .day
            ){
                continue
            }
            sum += treasurer.count
        }
        return sum
    }
}

