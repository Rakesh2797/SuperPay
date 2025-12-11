//
//  Transaction.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/11.
//

import Foundation

enum TransactionType: String, Codable {
    case purchase = "Purchase"
    case topUp = "Top Up"
}

struct Transaction: Identifiable, Codable {
    let id: String
    let type: TransactionType
    let amount: Double
    let date: Date
    let transactionId: String
    let items: [CartItem]?

    init(id: String = UUID().uuidString, type: TransactionType, amount: Double, date: Date = Date(), transactionId: String, items: [CartItem]? = nil) {
        self.id = id
        self.type = type
        self.amount = amount
        self.date = date
        self.transactionId = transactionId
        self.items = items
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: date)
    }

    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}

