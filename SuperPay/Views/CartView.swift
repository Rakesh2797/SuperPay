//
//  CartView.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/10.
//

import SwiftUI

struct CartView: View {
    @Binding var navigationPath: NavigationPath
    @ObservedObject var cartManager = CartManager.shared
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

            if cartManager.items.isEmpty {
                emptyCartView
            } else {
                cartContentView
            }
        }
        .navigationTitle("My Cart")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(red: 0.3, green: 0.5, blue: 0.85), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            if !cartManager.items.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation {
                            cartManager.clearCart()
                        }
                    }) {
                        Text("Clear")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }

    private var emptyCartView: some View {
        VStack(spacing: 24) {
            Image(systemName: "cart")
                .font(.system(size: 80))
                .foregroundColor(.white.opacity(0.6))

            VStack(spacing: 8) {
                Text("Your cart is empty")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Add some delicious products\nto get started")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
            }

            Button(action: {
                dismiss()
            }) {
                Text("Start Shopping")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
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
    }

    private var cartContentView: some View {
        VStack(spacing: 0) {
            // Wallet balance card
            walletBalanceCard

            // Cart items
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(cartManager.items) { item in
                        CartItemCard(item: item)
                    }
                }
                .padding()
                .padding(.bottom, 200) // Space for summary
            }

            Spacer()

            // Order summary
            orderSummaryCard
        }
    }

    private var walletBalanceCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Wallet Balance")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))

                Text("¥\(String(format: "%.0f", cartManager.walletBalance))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }

            Spacer()

            Image(systemName: "creditcard.fill")
                .font(.system(size: 32))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.3, green: 0.5, blue: 0.85).opacity(0.6),
                    Color(red: 0.4, green: 0.6, blue: 0.9).opacity(0.6)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
        .padding(.horizontal)
        .padding(.top)
    }

    private var orderSummaryCard: some View {
        VStack(spacing: 16) {
            // Summary details
            VStack(spacing: 12) {
                HStack {
                    Text("Subtotal")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))

                    Spacer()

                    Text("¥\(String(format: "%.0f", cartManager.totalAmount))")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }

                HStack {
                    Text("Items")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))

                    Spacer()

                    Text("\(cartManager.totalItemsCount)")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }

                Divider()
                    .background(Color.white.opacity(0.5))

                HStack {
                    Text("Total")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Spacer()

                    Text("¥\(String(format: "%.0f", cartManager.totalAmount))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal)

            // Checkout button
            Button(action: {
                navigationPath.append("checkout")
            }) {
                HStack {
                    Text("Proceed to Checkout")
                        .font(.headline)

                    Spacer()

                    Image(systemName: "arrow.right")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
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
            .disabled(cartManager.walletBalance < cartManager.totalAmount)
            .opacity(cartManager.walletBalance < cartManager.totalAmount ? 0.6 : 1.0)
            .padding(.horizontal)

            if cartManager.walletBalance < cartManager.totalAmount {
                Text("Insufficient wallet balance")
                    .font(.caption)
                    .foregroundColor(.red.opacity(0.9))
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(
            Color(red: 0.3, green: 0.5, blue: 0.85).opacity(0.8)
        )
    }
}

// MARK: - Cart Item Card
struct CartItemCard: View {
    let item: CartItem
    @ObservedObject var cartManager = CartManager.shared

    var body: some View {
        HStack(spacing: 16) {
            // Product image
            Text(item.product.imageURL)
                .font(.system(size: 50))
                .frame(width: 80, height: 80)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.9),
                                    Color(red: 0.9, green: 0.95, blue: 1.0)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )

            // Product details
            VStack(alignment: .leading, spacing: 6) {
                Text(item.product.name)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(item.product.category)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))

                Text("¥\(String(format: "%.0f", item.product.price)) each")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }

            Spacer()

            // Quantity controls and total
            VStack(spacing: 8) {
                HStack(spacing: 12) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            cartManager.removeFromCart(item.product)
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }

                    Text("\(item.quantity)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(minWidth: 30)

                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            cartManager.addToCart(item.product)
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                }

                Text("¥\(String(format: "%.0f", item.totalPrice))")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.3, green: 0.5, blue: 0.85).opacity(0.6),
                            Color(red: 0.4, green: 0.6, blue: 0.9).opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack(path: $path) {
        CartView(navigationPath: $path)
    }
}
