//
//  EditScreenViewController.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/11/01.
//

import UIKit

class EditScreenViewController: UIViewController ,UITextFieldDelegate{
    
    var productId: Int?
    var productsRepository: ProductsRepository?
    var treasurerRepository: TreasurerRepository?
    
    @IBOutlet weak var currentInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(insertAction))
        
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
    
    @objc func insertAction(){
        navigationItem.rightBarButtonItem?.isEnabled = false
        let currentCount: Int = Int(currentInput.text ?? "0")!
        Task.detached {
            do {
                guard let treasurerRepository = await self.treasurerRepository,
                      let productId = await self.productId
                else {
                    return
                }
                try await treasurerRepository.insertTreasurer(productId: productId, managerId: 1, count: Int(currentCount))
                await self.navigationController?.popViewController(animated: true)
                
                
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 数字と "-" のセットを作成
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789-")

        // 入力文字列が許可された文字だけで構成されているかチェック
        for scalar in string.unicodeScalars {
            if !allowedCharacterSet.contains(UnicodeScalar(scalar.value)!) {
                return false
            }
        }

        // 最初の文字が "-" の場合、それが唯一の "-" であることを確認
        if string == "-" {
            return !(textField.text?.contains("-") ?? false)
        }

        return true
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
