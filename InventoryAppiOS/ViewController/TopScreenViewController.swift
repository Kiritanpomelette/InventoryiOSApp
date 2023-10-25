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
    
    var productsRepository: ProductsRepository?
    var treasurerRepository: TreasurerRepository?
    
    var products: [Product] = []
    var treasurers: [Treasurer] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        indicator.startAnimating()
        fetchData()
    }
    
    @objc func fetchData(){
        Task.detached{
            do{
                print("Loading Products...")
                let products = try await self.productsRepository?.getAllProducts() ?? []
                print("Loading Treasurers...")
                let treasurers = try await self.treasurerRepository?.getAllTreasurer() ?? []
                await self.updateUI(products: products,treasurers: treasurers)
                print("Done!!")
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
        
        let product = products[indexPath.row]
        
        let filteredTreasurers = treasurers.filter { treasurer in
            treasurer.productId == product.id
        }
        
        cell.bind(product: product)
        cell.setCount(todayCount: filteredTreasurers.getTodayCount(), currentCount: filteredTreasurers.getCurrentCount())
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "openDetail", sender: nil)
        //tableView.deselectRow(at: indexPath, animated: true)
    }
        
    @MainActor
    func updateUI(products: [Product],treasurers: [Treasurer]){
        self.products = products
        self.treasurers = treasurers
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
        defaultContainer.register(TreasurerRepository.self) { _ in
            treasurerRepository
        }
        
        
        defaultContainer.storyboardInitCompleted(TopScreenViewController.self){ r,v in
            v.productsRepository = r.resolve(ProductsRepository.self)
            v.treasurerRepository = r.resolve(TreasurerRepository.self)
        }
        defaultContainer.storyboardInitCompleted(DetailScreenViewContorller.self){ r,v in
            v.repository = r.resolve(ProductsRepository.self)
        }
    }
}

