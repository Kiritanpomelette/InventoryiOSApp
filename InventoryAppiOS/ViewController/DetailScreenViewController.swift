//
//  DegailScreenViewController.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/19.
//

import UIKit

class DetailScreenViewContorller: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        treasures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailScreenTreasurerTableViewCell", for: indexPath) as! DetailScreenTreasurerTableViewCell
        
        cell.titleLabel.text = treasures[indexPath.row].modifyDate.formatted()
        return cell
        
    }
    
    
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    @IBOutlet weak var navitagionBar: UINavigationBar!
    
    var product: Product?
    var productId: Int?
    var productsRepository: ProductsRepository?
    var treasuresRepository: TreasurerRepository?
    
    var treasures: [Treasurer] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        tableView.register(UINib(nibName: "DetailScreenTreasurerTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailScreenTreasurerTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    func fetchData(){
        Task.detached{
            do{
                guard let productId = await self.productId else {
                    return
                }
                guard let product = try await self.productsRepository?.getProduct(id: productId) else {
                    return
                }
                guard let treasures = try await self.treasuresRepository?.getTreasurer(productId: product.id) else {
                    return
                }
                await self.updateUI(product: product,treasurers: treasures)
            }catch{
                
            }
        }
    }
    
    @MainActor
    func updateUI(product: Product?,treasurers: [Treasurer]){
        self.product = product
        self.treasures = treasurers
        print("UpdatingUI... \(String(describing: product))")
        tableView.reloadData()
        navigationBarTitle.title = product?.name
    }

}
