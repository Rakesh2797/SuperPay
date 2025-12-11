//
//  CheckoutViewModel.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/12.
//

import Foundation

enum CheckoutState: Equatable {
    case idle
    case processing
    case success(CheckoutResponse)
    case error(String)

    static func == (lhs: CheckoutState, rhs: CheckoutState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.processing, .processing):
            return true
        case (.success(let lhsResponse), .success(let rhsResponse)):
            return lhsResponse.transactionId == rhsResponse.transactionId
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

class CheckoutViewModel: ObservableObject {
    @Published var checkoutState: CheckoutState = .idle

    private let checkoutService = CheckoutService.shared
    private let cartManager = CartManager.shared

    var items: [CartItem] {
        cartManager.items
    }

    var totalAmount: Double {
        cartManager.totalAmount
    }

    var walletBalance: Double {
        cartManager.walletBalance
    }

    var canProceedToPayment: Bool {
        !items.isEmpty && walletBalance >= totalAmount
    }

    func processPayment() {
        guard canProceedToPayment else {
            checkoutState = .error("Unable to process payment")
            return
        }

        checkoutState = .processing

        Task {
            do {
                let response = try await checkoutService.processCheckout(
                    items: items,
                    totalAmount: totalAmount,
                    walletBalance: walletBalance
                )

                await MainActor.run {
                    // Deduct from wallet and clear cart on success
                    if cartManager.deductFromWallet(amount: totalAmount, transactionId: response.transactionId, items: items) {
                        cartManager.clearCart()
                        checkoutState = .success(response)
                    } else {
                        checkoutState = .error("Failed to deduct from wallet")
                    }
                }
            } catch let error as CheckoutError {
                await MainActor.run {
                    checkoutState = .error(error.localizedDescription)
                }
            } catch {
                await MainActor.run {
                    checkoutState = .error("An unexpected error occurred")
                }
            }
        }
    }

    func reset() {
        checkoutState = .idle
    }
}
