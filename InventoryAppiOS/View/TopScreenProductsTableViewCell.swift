//
//  MainTableViewCell.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/18.
//

import UIKit

class TopScreenProductsTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var currentCount: UILabel!
    @IBOutlet weak var todayCount: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    func bind(product: Product){
        title.text = product.name
        desc.text = product.memo
    }
}
