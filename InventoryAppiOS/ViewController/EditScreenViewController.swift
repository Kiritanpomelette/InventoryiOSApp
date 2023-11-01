//
//  EditScreenViewController.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/11/01.
//

import UIKit

class EditScreenViewController: UIViewController {
    
    var productId: Int?
    var productsRepository: ProductsRepository?
    var treasurerRepository: TreasurerRepository?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()

        // Do any additional setup after loading the view.
    }
    
    func fetchData(){
        Task.detached {
            do {
                if(await self.productId == nil) {
                    print("ProductId???")
                    return
                }
                guard let product = try await self.productsRepository?.getProduct(id: self.productId!) else {
                    return
                }
                await self.updateUI(product: product)
                
            }catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func updateUI(product: Product){
        title = product.name
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
