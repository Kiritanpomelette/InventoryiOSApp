//
//  TreasurerRepository.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/25.
//

import Foundation

protocol TreasurerRepository{
    func getTreasurer(productId: Int) async throws -> [Treasurer]
}

class FakeTreasurerRepository: TreasurerRepository {
    
    var treasurers: [Treasurer] = []
    
    init(repository: ProductsRepository){
        Task.detached{
            let products = try! await repository.getAllProducts()
            var id = 1
            products.forEach { i in
                for _ in (1...100){
                    let count = Int((100 % arc4random()) - 50)
                    let newTreasurer = Treasurer(id: id, productId: i.id, managerId: 1, modifyDate: Date(), count: count)
                    self.treasurers.append(newTreasurer)
                    id = id + 1
                }
            }
        }
    }
    
    func getTreasurer(productId: Int) async throws -> [Treasurer] {
        return treasurers.filter { i in
            i.productId == productId
        }
    }
}
