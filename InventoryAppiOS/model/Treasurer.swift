//
//  Treasurer.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/25.
//

import Foundation

struct Treasurer: Codable {
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
    
    func getThisWeekCount() -> Int {
        
        var sum = 0
        let today = Date()
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear,.weekOfYear], from: today))!
        let endOfWeek = calendar.date(byAdding: DateComponents(day: 7),to: startOfWeek)!
        for treasurer in self {
            if treasurer.modifyDate >= startOfWeek && treasurer.modifyDate < endOfWeek {
                sum += treasurer.count
            }
        }
        
        return sum
    }
    
    func getThisMonthCount() -> Int {
        var sum = 0
        let today = Date()
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        
        // Calculate the start of the next month
        let nextMonth = calendar.date(byAdding: DateComponents(month: 1), to: startOfMonth)!
        
        for treasurer in self {
            if treasurer.modifyDate >= startOfMonth && treasurer.modifyDate < nextMonth {
                sum += treasurer.count
            }
        }
        
        return sum
    }
}

