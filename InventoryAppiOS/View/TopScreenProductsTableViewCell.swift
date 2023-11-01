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
    @IBOutlet weak var currentCountLabel: UILabel!
    @IBOutlet weak var todayCountLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    func initilazition(){
        todayCountLabel.text = "Loading..."
        currentCountLabel.text = "Loading..."
    }
    
    func bind(product: Product){
        initilazition()

        title.text = product.name
        desc.text = product.memo
        
    }
    
    func setCount(todayCount: Int,currentCount: Int){
        todayCountLabel.text = String(todayCount)
        currentCountLabel.text = String(currentCount)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initilazition()
    }
}
