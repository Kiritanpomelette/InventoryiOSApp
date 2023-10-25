//
//  ProductsRepository.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/19.
//

import Foundation

protocol ProductsRepository {
    func getAllProducts() async -> [Product]
}

class FakeProductsRepository : ProductsRepository {
    var products: [Product] = {
        let fakeTitles = ["りんご","らっぱ","ぱんつ","つみき","あきたこまち Long Version Hello World","つや姫","コシヒカリ"]
        let fakeProducingAreas = ["北海道","東京","沖縄"]
        var tempProducts: [Product] = []
        
        for i in (0...100) {
            let tempProduct = Product(
                id: i,
                name: fakeTitles.randomElement()!,
                memo: String(arc4random()) + "円(" + fakeProducingAreas.randomElement()! + ")"
            )
            tempProducts.append(tempProduct)
        }
        return tempProducts
    }()
    func getAllProducts() async -> [Product] {
        try! await Task.sleep(nanoseconds: UInt64(arc4random()) % 5_000_000_000)
        return products
    }
}
