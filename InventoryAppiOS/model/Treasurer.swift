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
    let date: Date
    let count: Int
    static func getDecoder() -> JSONDecoder{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // これは一貫性のためにしばしば推奨されます
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 8) // タイムゾーンを指定する場合
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
}

extension Treasurer {
    func getDecoder() -> JSONDecoder{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // これは一貫性のためにしばしば推奨されます
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 8) // タイムゾーンを指定する場合
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
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
                equalTo: treasurer.date,
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
            if treasurer.date >= startOfWeek && treasurer.date < endOfWeek {
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
            if treasurer.date >= startOfMonth && treasurer.date < nextMonth {
                sum += treasurer.count
            }
        }
        
        return sum
    }
}

