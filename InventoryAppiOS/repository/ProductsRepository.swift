//
//  ProductsRepository.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/19.
//

import Foundation

protocol ProductsRepository {
    func getAllProducts() -> [Product]
}

class FakeProductsRepository : ProductsRepository {
    var products: [Product] = {
        let fakeTitles = ["りんご","らっぱ","ぱんつ","つみき","あきたこまち","つや姫","コシヒカリ"]
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
    func getAllProducts() -> [Product] {
        return products
    }
}
