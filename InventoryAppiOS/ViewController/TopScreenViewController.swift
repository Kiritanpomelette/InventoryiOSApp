//
//  ViewController.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/18.
//

import UIKit
import Swinject
import SwinjectStoryboard

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var repository: ProductsRepository?
    
    var products: [Product] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TopScreenProductsTableViewCell",
            for: indexPath
        ) as! TopScreenProductsTableViewCell
        
        let product = products[indexPath.row]
        cell.bind(product: product)
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
        
        products = repository!.getAllProducts()
        
        tableView.reloadData()
    }
    
    
}

extension SwinjectStoryboard {
    class public func setup() {
        defaultContainer.register(ProductsRepository.self){ _ in
            FakeProductsRepository()
        }
        defaultContainer.storyboardInitCompleted(ViewController.self){ r,v in
            #if DEBUG
            v.repository = r.resolve(ProductsRepository.self)
            #endif
        }
        
    }
}

