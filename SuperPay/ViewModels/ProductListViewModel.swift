//
//  ProductListViewModel.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/10.
//

import Foundation
import Combine

enum LoadingState {
    case idle
    case loading
    case success
    case error(String)
}

class ProductListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var loadingState: LoadingState = .idle
    @Published var searchText: String = ""
    @Published var selectedCategory: String = "All"

    private let cartManager = CartManager.shared
    private let productService = ProductService.shared

    var categories: [String] {
        let uniqueCategories = Set(products.map { $0.category })
        return ["All"] + uniqueCategories.sorted()
    }

    var filteredProducts: [Product] {
        var filtered = products

        // Filter by category
        if selectedCategory != "All" {
            filtered = filtered.filter { $0.category == selectedCategory }
        }

        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { product in
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.description.localizedCaseInsensitiveContains(searchText) ||
                product.category.localizedCaseInsensitiveContains(searchText)
            }
        }

        return filtered
    }

    func loadProducts() {
        loadingState = .loading

        Task {
            do {
                let fetchedProducts = try await productService.fetchProducts()
                await MainActor.run {
                    self.products = fetchedProducts
                    self.loadingState = .success
                }
            } catch {
                await MainActor.run {
                    self.loadingState = .error(error.localizedDescription)
                }
            }
        }
    }

    func addToCart(_ product: Product) {
        cartManager.addToCart(product)
    }

    func isInCart(_ product: Product) -> Bool {
        cartManager.items.contains { $0.product.id == product.id }
    }

    func getCartQuantity(for product: Product) -> Int {
        cartManager.items.first(where: { $0.product.id == product.id })?.quantity ?? 0
    }
}
