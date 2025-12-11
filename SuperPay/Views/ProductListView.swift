//
//  ProductListView.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/10.
//

import SwiftUI

struct ProductListView: View {
    @StateObject private var viewModel = ProductListViewModel()
    @ObservedObject var cartManager = CartManager.shared
    @State private var navigationPath = NavigationPath()
    @State private var navigateToWallet = false
    @State private var selectedProduct: Product?

    var body: some View {
        NavigationStack(path: $navigationPath) {
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

                VStack(spacing: 0) {
                    // Header with wallet balance
                    headerView

                    // Category filter
                    categoryScrollView

                    // Content
                    contentView
                }

                // Floating cart button
                if cartManager.totalItemsCount > 0 {
                    VStack {
                        Spacer()
                        floatingCartButton
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if viewModel.products.isEmpty {
                    viewModel.loadProducts()
                }
            }
            .navigationDestination(for: String.self) { destination in
                switch destination {
                case "cart":
                    CartView(navigationPath: $navigationPath)
                case "wallet":
                    WalletView()
                case "checkout":
                    CheckoutView(navigationPath: $navigationPath)
                default:
                    EmptyView()
                }
            }
            .navigationDestination(isPresented: $navigateToWallet) {
                WalletView()
            }
        }
    }

    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("SuperPay Market")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)

                    Text("Fresh products delivered daily")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }

                Spacer()

                // Wallet balance - tappable
                Button(action: {
                    navigationPath.append("wallet")
                }) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Wallet")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.9))

                        Text("¥\(String(format: "%.0f", cartManager.walletBalance))")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.2))
                    )
                }
            }

            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white.opacity(0.7))

                TextField("Search products...", text: $viewModel.searchText)
                    .foregroundColor(.white)
                    .accentColor(.white)

                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.2))
            )
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.2, green: 0.4, blue: 0.8),
                    Color(red: 0.3, green: 0.5, blue: 0.85)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }

    private var categoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.categories, id: \.self) { category in
                    CategoryChip(
                        title: category,
                        isSelected: viewModel.selectedCategory == category,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                viewModel.selectedCategory = category
                            }
                        }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(
            Color(red: 0.5, green: 0.7, blue: 0.95).opacity(0.3)
        )
    }

    private var floatingCartButton: some View {
        Button(action: {
            navigationPath.append("cart")
        }) {
            HStack(spacing: 12) {
                Image(systemName: "cart.fill")
                    .font(.system(size: 20))

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(cartManager.totalItemsCount) items")
                        .font(.caption)
                        .fontWeight(.medium)

                    Text("¥\(String(format: "%.0f", cartManager.totalAmount))")
                        .font(.headline)
                        .fontWeight(.bold)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
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
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.loadingState {
        case .idle, .loading:
            loadingView
        case .success:
            if viewModel.filteredProducts.isEmpty {
                emptyStateView
            } else {
                productListView
            }
        case .error(let message):
            errorView(message: message)
        }
    }

    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)

            Text("Loading products...")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.6))

            Text("No products found")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text(viewModel.searchText.isEmpty ?
                 "Try selecting a different category" :
                 "Try adjusting your search")
                .font(.body)
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            if !viewModel.searchText.isEmpty || viewModel.selectedCategory != "All" {
                Button(action: {
                    withAnimation {
                        viewModel.searchText = ""
                        viewModel.selectedCategory = "All"
                    }
                }) {
                    Text("Clear Filters")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var productListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredProducts) { product in
                    ProductCardView(
                        product: product,
                        onAddToCart: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.addToCart(product)
                                selectedProduct = product
                            }

                            // Haptic feedback
                            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                            impactFeedback.impactOccurred()
                        },
                        cartQuantity: viewModel.getCartQuantity(for: product)
                    )
                }

                // Bottom padding for floating cart button
                if cartManager.totalItemsCount > 0 {
                    Color.clear.frame(height: 80)
                }
            }
            .padding()
        }
        .refreshable {
            viewModel.loadProducts()
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.8))

            Text(message)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                viewModel.loadProducts()
            }) {
                Text("Retry")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ProductCardView: View {
    let product: Product
    let onAddToCart: () -> Void
    let cartQuantity: Int

    var body: some View {
        HStack(spacing: 16) {
            // Product emoji icon
            Text(product.imageURL)
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

            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.headline)
                    .foregroundColor(.white)

                Text(product.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)

                HStack {
                    Text(product.category)
                        .font(.caption2)
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.white)
                        )

                    Spacer()

                    Text("¥\(String(format: "%.0f", product.price))")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }

            Spacer()

            // Add to cart button
            VStack(spacing: 8) {
                Button(action: onAddToCart) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.white)
                }

                if cartQuantity > 0 {
                    Text("\(cartQuantity)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                        )
                }
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

// MARK: - Category Chip
struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? Color(red: 0.2, green: 0.4, blue: 0.8) : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.white : Color.white.opacity(0.2))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProductListView()
}
