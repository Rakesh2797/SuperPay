//
//  WalletView.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/11.
//

import SwiftUI

struct WalletView: View {
    @StateObject private var viewModel = WalletViewModel()
    @ObservedObject var cartManager = CartManager.shared
    @State private var selectedTransaction: Transaction?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // Background gradient
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
                    // Wallet balance card
                    walletBalanceCard

                    // Quick top-up buttons
                    quickTopUpSection

                    // Transaction history
                    transactionHistorySection
                }
                .padding()
            }
        }
        .navigationTitle("Wallet")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(red: 0.3, green: 0.5, blue: 0.85), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .sheet(isPresented: $viewModel.showAddMoneySheet) {
            AddMoneySheet(viewModel: viewModel)
        }
        .sheet(item: $selectedTransaction) { transaction in
            TransactionDetailView(transaction: transaction)
        }
    }

    private var walletBalanceCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Balance")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))

                    Text("¥\(String(format: "%.0f", viewModel.walletBalance))")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                }

                Spacer()

                Image(systemName: "wallet.pass.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white.opacity(0.8))
            }

            Button(action: {
                viewModel.showAddMoneySheet = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                    Text("Add Money")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.2, green: 0.4, blue: 0.8),
                            Color(red: 0.3, green: 0.5, blue: 0.9)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.3, green: 0.5, blue: 0.85).opacity(0.8),
                            Color(red: 0.4, green: 0.6, blue: 0.9).opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.15), radius: 15, x: 0, y: 8)
        )
    }

    private var quickTopUpSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Top Up")
                .font(.headline)
                .foregroundColor(.white)

            HStack(spacing: 12) {
                QuickTopUpButton(amount: 10000, onTap: {
                    viewModel.quickTopUp(amount: 10000)
                })

                QuickTopUpButton(amount: 25000, onTap: {
                    viewModel.quickTopUp(amount: 25000)
                })

                QuickTopUpButton(amount: 50000, onTap: {
                    viewModel.quickTopUp(amount: 50000)
                })
            }
        }
    }

    private var transactionHistorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Transaction History")
                .font(.headline)
                .foregroundColor(.white)

            if viewModel.transactions.isEmpty {
                emptyHistoryView
            } else {
                ForEach(viewModel.transactions) { transaction in
                    TransactionRow(transaction: transaction)
                        .onTapGesture {
                            selectedTransaction = transaction
                        }
                }
            }
        }
    }

    private var emptyHistoryView: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.6))

            Text("No transactions yet")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.2))
        )
    }
}

// MARK: - Quick Top Up Button
struct QuickTopUpButton: View {
    let amount: Double
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("¥\(String(format: "%.0f", amount))")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.2))
            )
        }
    }
}

// MARK: - Transaction Row
struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(transaction.type == .purchase ?
                          Color(red: 1.0, green: 0.4, blue: 0.4).opacity(0.4) :
                          Color(red: 0.4, green: 1.0, blue: 0.6).opacity(0.4))
                    .frame(width: 50, height: 50)

                Image(systemName: transaction.type == .purchase ? "cart.fill" : "arrow.down.circle.fill")
                    .font(.title3)
                    .foregroundColor(transaction.type == .purchase ?
                                   Color(red: 1.0, green: 0.2, blue: 0.3) :
                                   Color(red: 0.3, green: 1.0, blue: 0.5))
            }

            // Details
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.type.rawValue)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(transaction.shortDate)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            // Amount
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(transaction.type == .purchase ? "-" : "+")¥\(String(format: "%.0f", transaction.amount))")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(transaction.type == .purchase ?
                                   Color(red: 1.0, green: 0.2, blue: 0.3) :
                                   Color(red: 0.3, green: 1.0, blue: 0.5))

                if transaction.items != nil {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.2))
        )
    }
}

// MARK: - Add Money Sheet
struct AddMoneySheet: View {
    @ObservedObject var viewModel: WalletViewModel
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

                VStack(spacing: 24) {
                    Spacer()

                    VStack(spacing: 16) {
                        Text("Enter Amount")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        HStack {
                            Text("¥")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)

                            TextField("0", text: $viewModel.topUpAmount)
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.2))
                        )
                    }
                    .padding()

                    VStack(spacing: 12) {
                        Text("Quick Amounts")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))

                        VStack(spacing: 12) {
                            HStack(spacing: 12) {
                                QuickAmountButton(amount: 10000, viewModel: viewModel)
                                QuickAmountButton(amount: 25000, viewModel: viewModel)
                            }
                            HStack(spacing: 12) {
                                QuickAmountButton(amount: 50000, viewModel: viewModel)
                                QuickAmountButton(amount: 100000, viewModel: viewModel)
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                    Button(action: {
                        viewModel.addMoney()
                    }) {
                        Text("Add Money")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.2, green: 0.4, blue: 0.8),
                                        Color(red: 0.3, green: 0.5, blue: 0.9)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                    }
                    .disabled(!viewModel.isValidAmount)
                    .opacity(viewModel.isValidAmount ? 1.0 : 0.6)
                    .padding()
                }
            }
            .navigationTitle("Add Money")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

// MARK: - Quick Amount Button
struct QuickAmountButton: View {
    let amount: Double
    @ObservedObject var viewModel: WalletViewModel

    var body: some View {
        Button(action: {
            viewModel.topUpAmount = String(format: "%.0f", amount)
        }) {
            Text("¥\(String(format: "%.0f", amount))")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.2))
                )
        }
    }
}

#Preview {
    NavigationStack {
        WalletView()
    }
}
