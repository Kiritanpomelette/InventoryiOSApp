//
//  ViewController.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/18.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TopScreenProductsTableViewCell",
            for: indexPath
        ) as! TopScreenProductsTableViewCell
        
        cell.title.text = String(arc4random())
        cell.detailButton.addTarget(self, action: #selector(onDetailButtonTap(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func onDetailButtonTap(sender:Any){
        performSegue(withIdentifier: "openDetail", sender: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()  
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "TopScreenProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "TopScreenProductsTableViewCell")
    }
}

