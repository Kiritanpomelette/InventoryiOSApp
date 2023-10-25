//
//  DegailScreenViewController.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/19.
//

import UIKit

class DetailScreenViewContorller: UIViewController {
    
    @IBOutlet weak var navigationBarTitle: UINavigationItem!
    @IBOutlet weak var navitagionBar: UINavigationBar!
    
    var product: Product?
    var productId: Int?
    var repository: ProductsRepository?


    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    func fetchData(){
        Task.detached{
            do{
                guard let productId = await self.productId else {
                    return
                }
                guard let product = try await self.repository?.getProduct(id: productId) else {
                    return
                }
                await self.updateUI(product: product)
            }catch{
                
            }
        }
    }
    
    @MainActor
    func updateUI(product: Product?){
        self.product = product
        print("UpdatingUI... \(String(describing: product))")
        navigationBarTitle.title = product?.name
    }

}
