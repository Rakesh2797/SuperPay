//
//  TransactionDetailView.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/11.
//

import SwiftUI

struct TransactionDetailView: View {
    let transaction: Transaction
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.6, green: 0.8, blue: 1.0),
                        Color(red: 0.4, green: 0.6, blue: 0.9)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Transaction icon and type
                        headerSection

                        // Transaction details
                        detailsSection

                        // Items (if purchase)
                        if let items = transaction.items, !items.isEmpty {
                            itemsSection(items: items)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Transaction Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(red: 0.3, green: 0.5, blue: 0.85), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(transaction.type == .purchase ?
                          Color.red.opacity(0.3) :
                          Color.green.opacity(0.3))
                    .frame(width: 100, height: 100)

                Image(systemName: transaction.type == .purchase ? "cart.fill" : "arrow.down.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(transaction.type == .purchase ? .red : .green)
            }

            Text(transaction.type.rawValue)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text("\(transaction.type == .purchase ? "-" : "+")¥\(String(format: "%.0f", transaction.amount))")
                .font(.system(size: 42, weight: .bold))
                .foregroundColor(transaction.type == .purchase ? .red : .green)
        }
        .padding()
    }

    private var detailsSection: some View {
        VStack(spacing: 0) {
            DetailItemRow(label: "Transaction ID", value: transaction.transactionId)
            Divider().background(Color.white.opacity(0.3))
            DetailItemRow(label: "Date & Time", value: transaction.formattedDate)
            Divider().background(Color.white.opacity(0.3))
            DetailItemRow(label: "Status", value: "Completed", valueColor: .green)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.2))
        )
    }

    private func itemsSection(items: [CartItem]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Items Purchased")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)

            VStack(spacing: 12) {
                ForEach(items) { item in
                    PurchasedItemRow(item: item)
                }
            }
        }
    }
}

// MARK: - Detail Item Row
struct DetailItemRow: View {
    let label: String
    let value: String
    var valueColor: Color = .white

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))

            Spacer()

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(valueColor)
        }
        .padding()
    }
}

// MARK: - Purchased Item Row
struct PurchasedItemRow: View {
    let item: CartItem

    var body: some View {
        HStack(spacing: 16) {
            Text(item.product.imageURL)
                .font(.system(size: 40))
                .frame(width: 60, height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.9))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.headline)
                    .foregroundColor(.white)

                HStack(spacing: 4) {
                    Text("¥\(String(format: "%.0f", item.product.price))")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))

                    Text("×")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))

                    Text("\(item.quantity)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
            }

            Spacer()

            Text("¥\(String(format: "%.0f", item.totalPrice))")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.2))
        )
    }
}

#Preview {
    TransactionDetailView(
        transaction: Transaction(
            type: .purchase,
            amount: 2320,
            transactionId: "TXN-1733800000-1234",
            items: [
                CartItem(product: Product.mockProducts[0], quantity: 2),
                CartItem(product: Product.mockProducts[4], quantity: 1)
            ]
        )
    )
}
