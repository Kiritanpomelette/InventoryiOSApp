//
//  DetailScreenTreasurerTableViewCell.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/25.
//

import UIKit

class DetailScreenTreasurerTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
