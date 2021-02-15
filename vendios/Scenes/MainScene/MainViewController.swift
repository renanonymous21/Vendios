//
//  ViewController.swift
//  vendios
//
//  Created by Rendy K.R on 23/12/20.
//

import UIKit
class MainViewController: UIViewController {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    
    var currentBalance: Int = 0 {
        didSet {
            let oldVal = oldValue
            let newVal = currentBalance
            
            if oldVal != newVal {
                currentBalanceLabel.text = "IDR \(newVal)"
            }
        }
    }
    
    lazy var productsShow: ProductCollectionView = {
        let product = ProductCollectionView()
        return product
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        productCollectionView.dataSource = productsShow
        productCollectionView.delegate = productsShow
        productsShow.delegate = self
        
        let alreadyLaunchedApp = UserDefaults.standard.bool(forKey: "alreadyLaunchedApp")
        
        productsShow.data = fetchProducts(firstTimeLaunch: alreadyLaunchedApp)
        productCollectionView.reloadData()
        
    }
    
    @IBAction func IDR2kTapped(_ sender: Any) {
        currentBalance += 2000
        productsShow.currentBalance = currentBalance
    }
    @IBAction func IDR5kTapped(_ sender: Any) {
        currentBalance += 5000
        productsShow.currentBalance = currentBalance
    }
    @IBAction func IDR10kTapped(_ sender: Any) {
        currentBalance += 10000
        productsShow.currentBalance = currentBalance
    }
    @IBAction func IDR20kTapped(_ sender: Any) {
        currentBalance += 20000
        productsShow.currentBalance = currentBalance
    }
    @IBAction func IDR50kTapped(_ sender: Any) {
        currentBalance += 50000
        productsShow.currentBalance = currentBalance
    }
    @IBAction func refreshStock(_ sender: Any) {
        refreshData()
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if currentBalance > 0 {
            let alert = UIAlertController(title: "", message: "Here's your change after making purchase: IDR \(currentBalance)", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: {
                _ in
                
                self.currentBalance = 0
            })
            alert.addAction(okay)
            alert.show()
        }
    }
}

extension MainViewController: ProductDelegate {
    
    func refreshData() {
        do {
            let data = try ProductOperations.readProducts()
            if data.count > 0 {
                ProductOperations.deleteAllProducts(EntityName.Products.rawValue)
            }
            if let file = Bundle.main.path(forResource: "products", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: file), options: .mappedIfSafe)
                let decode = try JSONDecoder().decode([ProductModel].self, from: data)
                for data in decode {
                    print(data.name)
                    ProductOperations.insertProduct(productID: data.id, productName: data.name, assetName: data.assetCode, stock: data.stock, price: data.price)
                }
                productsShow.data = try ProductOperations.readProducts()
                productCollectionView.reloadData()
                
            }
        } catch let error {
            print(error)
        }
    }
    
    func updateCurrentBalance(productPrice: Int) {
        currentBalance -= productPrice
        currentBalanceLabel.text = "IDR \(currentBalance)"
        productsShow.currentBalance = currentBalance
    }
    
    func fetchProducts(firstTimeLaunch: Bool) -> [ProductModel] {
        if firstTimeLaunch {
            do {
                return try ProductOperations.readProducts()
            } catch let error {
                print(error)
            }
        } else {
            do {
                let data = try ProductOperations.readProducts()
                if data.count > 0 {
                    ProductOperations.deleteAllProducts(EntityName.Products.rawValue)
                }
                if let file = Bundle.main.path(forResource: "products", ofType: "json") {
                    let data = try Data(contentsOf: URL(fileURLWithPath: file), options: .mappedIfSafe)
                    let decode = try JSONDecoder().decode([ProductModel].self, from: data)
                    for data in decode {
                        ProductOperations.insertProduct(productID: data.id, productName: data.name, assetName: data.assetCode, stock: data.stock, price: data.price)
                    }
                    return try ProductOperations.readProducts()
                }
            } catch let error {
                print(error)
            }
        }
        
        return []
    }
}

