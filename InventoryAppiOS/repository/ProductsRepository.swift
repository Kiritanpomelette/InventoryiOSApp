//
//  ProductsRepository.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/19.
//

import Foundation

protocol ProductsRepository {
    func getAllProducts() async throws -> [Product]
    func getProduct(id: Int) async throws -> Product?
}

class ProductsRepositoryImpl : ProductsRepository {
    func getAllProducts() async throws -> [Product] {
        let url = URL(string: "https://n3.miyayu.xyz/InventoryServer-0.0.1-SNAPSHOT-plain/products")!
        let (data,_) = try! await URLSession.shared.data(from: url)
        return try! JSONDecoder().decode([Product].self, from: data)
    }
    func getProduct(id: Int) async throws -> Product? {
        let url = URL(string: "https://n3.miyayu.xyz/InventoryServer-0.0.1-SNAPSHOT-plain/products/selectID?id=\(id)")!
        let (data,_) = try! await URLSession.shared.data(from: url)
        return try! JSONDecoder().decode(Product.self, from: data)
    }
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
    func getAllProducts() async throws -> [Product]{
        try! await Task.sleep(nanoseconds: UInt64(arc4random()) % 1_000_000_000)
        return products
    }
    func getProduct(id: Int) async throws -> Product? {
        return products.first(where: { $0.id == id })
    }
}
