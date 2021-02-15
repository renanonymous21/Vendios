//
//  ProductModel.swift
//  vendios
//
//  Created by Rendy K.R on 23/12/20.
//

import UIKit

struct ProductModel: Equatable, Codable {
    
    let id: UUID
    let assetCode: String
    let name: String
    var stock: Int
    let price: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case assetCode = "asset_code"
        case name = "name"
        case stock = "stock"
        case price = "price"
    }
}

func ==(left: ProductModel, right: ProductModel) -> Bool {
    return left.id == right.id
        && left.assetCode == right.assetCode
        && left.name == right.name
        && left.stock == right.stock
        && left.price == right.price
}
