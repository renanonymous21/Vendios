//
//  ProductCollectionView.swift
//  vendios
//
//  Created by Rendy K.R on 23/12/20.
//

import UIKit

protocol ProductDelegate {
    func updateCurrentBalance(productPrice: Int)
}

class ProductCollectionView: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    var data = [ProductModel]()
    var delegate: ProductDelegate?
    var currentBalance: Int?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCells", for: indexPath) as! ProductCollectionViewCell
        let products = data[indexPath.item]
        
        cell.productImage.image = UIImage(named: products.assetCode)
        cell.productNamePriceLabel.text = products.name + " - IDR " + String(products.price)
        
        if products.stock > 0 {
            cell.stockLabel.text = "\(products.stock) left"
        } else {
            cell.stockLabel.text = "Out of stock"
            cell.infoLabel.backgroundColor = .darkGray
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let price = data[indexPath.item].price
        let id = data[indexPath.item].id
        let stock = data[indexPath.item].stock
        
        if let myBalance = currentBalance {
            do {
                if myBalance >= price && stock > 0 {
                    ProductOperations.updateStock(productID: id, stock: stock-1)
                    data = try ProductOperations.readProducts()
                    setStockLabel(dataStock: ProductOperations.checkLatestStock(productID: id), collectionView: collectionView, indexPath: indexPath)
                    self.delegate?.updateCurrentBalance(productPrice: price)
                } else if myBalance <= price && stock > 0 {
                    showAlert(title: "", message: "Your balance isn't enough to buy this item")
                } else if myBalance >= price && stock == 0 {
                    showAlert(title: "Oops", message: "Sorry, this item already sold out")
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func setStockLabel(dataStock: Int, collectionView: UICollectionView,indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProductCollectionViewCell
        
        if dataStock > 0 {
            cell.stockLabel.text = "\(dataStock) left"
        } else {
            cell.stockLabel.text = "Out of stock"
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alert.addAction(okay)
        alert.show()
    }
}
