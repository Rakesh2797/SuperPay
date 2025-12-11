//
//  CartManager.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/10.
//

import Foundation
import Combine

class CartManager: ObservableObject {
    static let shared = CartManager()

    @Published var items: [CartItem] = []
    @Published var walletBalance: Double = 150000.0
    @Published var transactions: [Transaction] = []

    private let cartItemsKey = "cartItems"
    private let walletBalanceKey = "walletBalance"
    private let transactionsKey = "transactions"

    private init() {
        loadCart()
        loadWalletBalance()
        loadTransactions()
    }

    var totalAmount: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }

    var totalItemsCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    func addToCart(_ product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(product: product, quantity: 1))
        }
        saveCart()
    }

    func removeFromCart(_ product: Product) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            if items[index].quantity > 1 {
                items[index].quantity -= 1
            } else {
                items.remove(at: index)
            }
        }
        saveCart()
    }

    func updateQuantity(for product: Product, quantity: Int) {
        if let index = items.firstIndex(where: { $0.product.id == product.id }) {
            if quantity > 0 {
                items[index].quantity = quantity
            } else {
                items.remove(at: index)
            }
        }
        saveCart()
    }

    func clearCart() {
        items.removeAll()
        saveCart()
    }

    func deductFromWallet(amount: Double, transactionId: String, items: [CartItem]) -> Bool {
        if walletBalance >= amount {
            walletBalance -= amount
            saveWalletBalance()

            // Add purchase transaction
            let transaction = Transaction(
                type: .purchase,
                amount: amount,
                transactionId: transactionId,
                items: items
            )
            addTransaction(transaction)

            return true
        }
        return false
    }

    func addToWallet(amount: Double) {
        walletBalance += amount
        saveWalletBalance()

        // Add top-up transaction
        let transactionId = "TXN-\(Int(Date().timeIntervalSince1970))-\(Int.random(in: 1000...9999))"
        let transaction = Transaction(
            type: .topUp,
            amount: amount,
            transactionId: transactionId
        )
        addTransaction(transaction)
    }

    private func addTransaction(_ transaction: Transaction) {
        transactions.insert(transaction, at: 0)
        saveTransactions()
    }

    private func saveCart() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: cartItemsKey)
        }
    }

    private func loadCart() {
        if let data = UserDefaults.standard.data(forKey: cartItemsKey),
           let decoded = try? JSONDecoder().decode([CartItem].self, from: data) {
            items = decoded
        }
    }

    private func saveWalletBalance() {
        UserDefaults.standard.set(walletBalance, forKey: walletBalanceKey)
    }

    private func loadWalletBalance() {
        let balance = UserDefaults.standard.double(forKey: walletBalanceKey)
        walletBalance = balance > 0 ? balance : 150000.0
    }

    private func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: transactionsKey)
        }
    }

    private func loadTransactions() {
        if let data = UserDefaults.standard.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        } else {
            // Start with empty transactions
            transactions = []
        }
    }
}
