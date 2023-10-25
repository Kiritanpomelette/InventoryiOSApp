//
//  ViewController.swift
//  InventoryAppiOS
//
//  Created by Miyayu on 2023/10/18.
//

import UIKit
import Swinject
import SwinjectStoryboard

class TopScreenViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var repository: ProductsRepository?
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        indicator.startAnimating()
        fetchData()
    }
    
    @objc func fetchData(){
        Task.detached{
            do{
                let products = try await self.repository?.getAllProducts() ?? []
                await self.updateUI(products: products)
            }catch{
                print("Error fetching products: \(error)")
            }
        }
    }
    func setupTableView(){
        tableView.register(UINib(nibName: "TopScreenProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "TopScreenProductsTableViewCell")
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルの定義
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TopScreenProductsTableViewCell",
            for: indexPath
        ) as! TopScreenProductsTableViewCell
        
        cell.bind(product: products[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "openDetail", sender: nil)
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @MainActor
    func updateUI(products: [Product]){
        self.products = products
        tableView.reloadData()
        indicator.stopAnimating()
        tableView.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openDetail" {
            guard let selectedRow = tableView.indexPathForSelectedRow?.row,
                  let selectedProduct = products[safe: selectedRow] else {
                return
            }
            if let nextVC = segue.destination as? DetailScreenViewContorller {
                nextVC.productId = selectedProduct.id
            }
        }
    }
}

extension SwinjectStoryboard {
    class public func setup() {
        let productsRepository: ProductsRepository = FakeProductsRepository()
        let treasurerRepository: TreasurerRepository = FakeTreasurerRepository(repository: productsRepository)
        
        defaultContainer.register(ProductsRepository.self){ _ in
            productsRepository
        }
        defaultContainer.storyboardInitCompleted(TopScreenViewController.self){ r,v in
#if DEBUG
            v.repository = r.resolve(ProductsRepository.self)
#endif
        }
        defaultContainer.storyboardInitCompleted(DetailScreenViewContorller.self){ r,v in
#if DEBUG
            v.repository = r.resolve(ProductsRepository.self)
#endif
            
        }
    }
}

