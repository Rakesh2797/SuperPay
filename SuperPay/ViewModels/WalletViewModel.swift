//
//  WalletViewModel.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/11.
//

import Foundation

class WalletViewModel: ObservableObject {
    @Published var topUpAmount: String = ""
    @Published var showAddMoneySheet: Bool = false

    private let cartManager = CartManager.shared

    var walletBalance: Double {
        cartManager.walletBalance
    }

    var transactions: [Transaction] {
        cartManager.transactions
    }

    var isValidAmount: Bool {
        guard let amount = Double(topUpAmount), amount > 0 else {
            return false
        }
        return true
    }

    func addMoney() {
        guard let amount = Double(topUpAmount), amount > 0 else {
            return
        }

        cartManager.addToWallet(amount: amount)
        topUpAmount = ""
        showAddMoneySheet = false
    }

    func quickTopUp(amount: Double) {
        cartManager.addToWallet(amount: amount)
    }
}
