//
//  CollectionExt.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/25.
//

import Foundation

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
