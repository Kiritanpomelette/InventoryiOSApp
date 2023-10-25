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
}

class FakeTreasurerRepository: TreasurerRepository {
    
    var treasurers: [Treasurer] = []
    var initTask: Task<(),Never>? = nil
    
    init(repository: ProductsRepository){
        let currentDate = Date()
        let borderDate:Int64 = -1*60*60*24*31*3
        
        initTask = Task{
            let products = try! await repository.getAllProducts()
            var id = 1
            products.forEach { i in
                for index in (1...25){
                    //出納数
                    let treasureCount = Int.random(in: -50..<51)
                    let interval: TimeInterval = (index == 1) ? TimeInterval(0) : TimeInterval(Int64.random(in: borderDate..<0))
                    //ダミーの出納情報
                    let dummyTreasurer = Treasurer(
                        id: id,
                        productId: i.id,
                        managerId: 1,
                        modifyDate: Date(timeInterval: interval, since: currentDate),
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
}
