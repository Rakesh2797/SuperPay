//
//  CheckoutService.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/12.
//

import Foundation

enum CheckoutError: Error, LocalizedError {
    case insufficientFunds
    case networkError
    case invalidAmount
    case serverError

    var errorDescription: String? {
        switch self {
        case .insufficientFunds:
            return "Insufficient funds in your wallet"
        case .networkError:
            return "Network connection failed. Please try again."
        case .invalidAmount:
            return "Invalid transaction amount"
        case .serverError:
            return "Server error occurred. Please try again later."
        }
    }
}

struct CheckoutRequest: Codable {
    let items: [CartItem]
    let totalAmount: Double
    let walletBalance: Double
    let timestamp: Date
}

struct CheckoutResponse: Codable {
    let success: Bool
    let transactionId: String
    let message: String
    let remainingBalance: Double
}

class CheckoutService {
    static let shared = CheckoutService()

    private init() {}

    /// Simulates a POST /checkout endpoint with random success/failure and delay
    func processCheckout(
        items: [CartItem],
        totalAmount: Double,
        walletBalance: Double
    ) async throws -> CheckoutResponse {
        // Random delay between 1-3 seconds to simulate network call
        let delay = Double.random(in: 1.0...3.0)
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))

        // Validate amount
        guard totalAmount > 0 else {
            throw CheckoutError.invalidAmount
        }

        // Check wallet balance
        guard walletBalance >= totalAmount else {
            throw CheckoutError.insufficientFunds
        }

        // Simulate 20% failure rate (80% success)
        let shouldSucceed = Int.random(in: 1...10) <= 8

        if !shouldSucceed {
            // Randomly choose between network error and server error
            throw Bool.random() ? CheckoutError.networkError : CheckoutError.serverError
        }

        // Success case
        let transactionId = generateTransactionId()
        let remainingBalance = walletBalance - totalAmount

        return CheckoutResponse(
            success: true,
            transactionId: transactionId,
            message: "Payment successful!",
            remainingBalance: remainingBalance
        )
    }

    private func generateTransactionId() -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let random = Int.random(in: 1000...9999)
        return "TXN-\(timestamp)-\(random)"
    }
}
