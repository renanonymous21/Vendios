//
//  ProductOperations.swift
//  vendios
//
//  Created by Rendy K.R on 24/12/20.
//

import UIKit
import CoreData

protocol ProductCoreDataProtocol {
    static func insertProduct(productID: UUID, productName: String, assetName: String, stock: Int, price: Int)
}

class ProductOperations: ProductCoreDataProtocol {
    static func insertProduct(productID: UUID, productName: String, assetName: String, stock: Int, price: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let ctx = appDelegate.persistentContainer.viewContext
        let productEntity = NSEntityDescription.entity(forEntityName: EntityName.Products.rawValue, in: ctx)
        let insert = NSManagedObject(entity: productEntity!, insertInto: ctx)
        
        insert.setValue(productID, forKey: "productID")
        insert.setValue(productName, forKey: "productName")
        insert.setValue(assetName, forKey: "assetName")
        insert.setValue(stock, forKey: "stock")
        insert.setValue(price, forKey: "price")
        
        do {
            try ctx.save()
        } catch let error {
            print(error)
        }
    }
    
    static func readProducts() throws -> [ProductModel] {
        var products = [ProductModel]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let ctx = appDelegate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.Products.rawValue)
        
        do {
            let res = try ctx.fetch(fetchReq) as! [NSManagedObject]
            res.forEach {
                product in
                
                products.append(
                    ProductModel(
                        id: product.value(forKey: "productID") as! UUID,
                        assetCode: product.value(forKey: "assetName") as! String,
                        name: product.value(forKey: "productName") as! String,
                        stock: product.value(forKey: "stock") as! Int,
                        price: product.value(forKey: "price") as! Int
                    )
                )
            }
        } catch let error {
            print(error)
        }
        
        return products
    }
    
    static func updateStock(productID: UUID, stock: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let ctx = appDelegate.persistentContainer.viewContext
        let fetchReq: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: EntityName.Products.rawValue)
        fetchReq.predicate = NSPredicate(format: "productID = %@", productID as CVarArg)
        
        do {
            let fetch = try ctx.fetch(fetchReq)
            let data = fetch[0] as! NSManagedObject
            data.setValue(stock, forKey: "stock")
            
            try ctx.save()
        } catch let error {
            print(error)
        }
    }
    
    static func checkLatestStock(productID: UUID) -> Int {
        var latestStock = 0
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let ctx = appDelegate.persistentContainer.viewContext
        let fetchReq: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: EntityName.Products.rawValue)
        fetchReq.predicate = NSPredicate(format: "productID = %@", productID as CVarArg)
        
        do {
            let fetch = try ctx.fetch(fetchReq)
            let data = fetch[0] as! NSManagedObject
            latestStock = data.value(forKey: "stock") as! Int
        } catch let error {
            print(error)
        }
        
        return latestStock
    }
    
    static func deleteAllProducts(_ entity:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                appDelegate.persistentContainer.viewContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
}
