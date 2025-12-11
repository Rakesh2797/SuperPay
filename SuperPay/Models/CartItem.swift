//
//  CartItem.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/09.
//

import Foundation

struct CartItem: Identifiable, Codable {
    let id: String
    let product: Product
    var quantity: Int

    init(product: Product, quantity: Int = 1) {
        self.id = product.id
        self.product = product
        self.quantity = quantity
    }

    var totalPrice: Double {
        product.price * Double(quantity)
    }
}
