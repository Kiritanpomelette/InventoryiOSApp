//
//  TreasurerRepository.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/25.
//

import Foundation

protocol TreasurerRepository{
    func getAllTreasurer() async throws -> [Treasurer]
    func getTreasurer(productId: Int) async throws -> [Treasurer]
    func insertTreasurer(productId: Int,managerId: Int,count: Int) async throws
}

class TreasurerRepositoryImpl: TreasurerRepository {
    func getAllTreasurer() async throws -> [Treasurer] {
        let url = URL(string: "https://n3.miyayu.xyz/InventoryServer-0.0.1-SNAPSHOT-plain/treasurer")!
        let (data,_) = try! await URLSession.shared.data(from: url)
        return try! Treasurer.getDecoder().decode([Treasurer].self, from: data)
    }
    func getTreasurer(productId: Int) async throws -> [Treasurer] {
        let url = URL(string: "https://n3.miyayu.xyz/InventoryServer-0.0.1-SNAPSHOT-plain/treasurer/selectID?productId=\(productId)")!
        let (data,_) = try! await URLSession.shared.data(from: url)
        return try! Treasurer.getDecoder().decode([Treasurer].self, from: data)
    }
    func insertTreasurer(productId: Int, managerId: Int, count: Int) async throws {
        let url = URL(string: "https://n3.miyayu.xyz/InventoryServer-0.0.1-SNAPSHOT-plain/treasurer")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "productId=\(productId)&managerId=\(managerId)&count=\(count)".data(using: .utf8)
        
        print(request)
        let (data,_) = try! await URLSession.shared.data(for: request)
        print(data.base64EncodedString())
    }
}

class FakeTreasurerRepository: TreasurerRepository {
    
    var treasurers: [Treasurer] = []
    var initTask: Task<(),Never>? = nil
    
    init(repository: ProductsRepository){
        let currentDate = Date()
        let borderDate:Int64 = -1*60*60*24*(31+10)
        
        initTask = Task{
            let products = try! await repository.getAllProducts()
            var id = 1
            products.forEach { i in
                for index in (1...100){
                    //出納数
                    let treasureCount = Int.random(in: -50..<51)
                    let interval: TimeInterval = (index == 1) ? TimeInterval(0) : TimeInterval(Int64.random(in: borderDate..<0))
                    //ダミーの出納情報
                    let dummyTreasurer = Treasurer(
                        id: id,
                        productId: i.id,
                        managerId: 1,
                        date: Date(timeInterval: interval, since: currentDate),
                        count: treasureCount
                    )
                    //出納情報をリストに追加する
                    self.treasurers.append(dummyTreasurer)
                    id = id + 1
                }
            }
        }
    }
    
    func getAllTreasurer() async throws -> [Treasurer] {
        do{
            await initTask?.value
            try await Task.sleep(nanoseconds: UInt64.random(in: 0_500_000_000..<1_000_000_000))
            return treasurers
        }catch{
            print("Error")
            return []
        }
    }
    
    func getTreasurer(productId: Int) async throws -> [Treasurer] {
        do{
            await initTask?.value
            
            try await Task.sleep(nanoseconds: UInt64.random(in: 0_500_000_000..<1_500_000_000))
        
            let filteredData = treasurers.filter { i in
                i.productId == productId
            }
            return filteredData
        }catch{
            print("Error")
            return []
        }
    }
    
    func insertTreasurer(productId: Int, managerId: Int, count: Int) async throws {
        do {
            await initTask?.value
            try await Task.sleep(nanoseconds: UInt64.random(in: 0_500_000_000..<1_500_000_000))

            let newTreasurerData = Treasurer(
                id: Int(arc4random()),
                productId: productId,
                managerId: managerId,
                date: Date(),
                count: count
            )
            
            treasurers.append(newTreasurerData)
        }
    }
    
}
