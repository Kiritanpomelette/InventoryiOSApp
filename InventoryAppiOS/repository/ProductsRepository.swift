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
    func getAllProducts() -> [Product] {
        return [Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),
                Product(id: 1, name: "りんご", memo: "おいしいりんご"),]
    }
}
