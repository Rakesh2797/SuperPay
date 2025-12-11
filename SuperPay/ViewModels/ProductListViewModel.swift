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

        // Simulate API call with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }

            // Simulate random success/failure (90% success rate)
            let shouldSucceed = Int.random(in: 1...10) <= 9

            if shouldSucceed {
                self.products = Product.mockProducts
                self.loadingState = .success
            } else {
                self.loadingState = .error("Failed to load products. Please try again.")
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
