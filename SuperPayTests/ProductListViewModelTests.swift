//
//  ProductListViewModelTests.swift
//  SuperPayTests
//
//  Created by Kota Rakesh on 2025/12/12.
//

import XCTest
import Combine
@testable import SuperPay

final class ProductListViewModelTests: XCTestCase {
    var viewModel: ProductListViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        viewModel = ProductListViewModel()
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: - Test 1: Initial State
    func testInitialState() {
        XCTAssertTrue(viewModel.products.isEmpty, "Products should be empty initially")
        XCTAssertEqual(viewModel.searchText, "", "Search text should be empty initially")
        XCTAssertEqual(viewModel.selectedCategory, "All", "Selected category should be 'All' initially")
    }

    // MARK: - Test 2: Categories Array
    func testCategoriesWithNoProducts() {
        XCTAssertEqual(viewModel.categories, ["All"], "Categories should only contain 'All' when no products")
    }

    // MARK: - Test 3: Categories With Products
    func testCategoriesWithProducts() {
        viewModel.products = [
            Product(name: "Apple", description: "Fresh apple", price: 100, imageURL: "🍎", category: "Fruits"),
            Product(name: "Milk", description: "Fresh milk", price: 200, imageURL: "🥛", category: "Dairy"),
            Product(name: "Banana", description: "Fresh banana", price: 150, imageURL: "🍌", category: "Fruits")
        ]

        let categories = viewModel.categories
        XCTAssertTrue(categories.contains("All"), "Categories should contain 'All'")
        XCTAssertTrue(categories.contains("Fruits"), "Categories should contain 'Fruits'")
        XCTAssertTrue(categories.contains("Dairy"), "Categories should contain 'Dairy'")
        XCTAssertEqual(categories.count, 3, "Should have 3 categories: All, Fruits, Dairy")
    }

    // MARK: - Test 4: Filtered Products - All Category
    func testFilteredProductsWithAllCategory() {
        viewModel.products = [
            Product(name: "Apple", description: "Fresh apple", price: 100, imageURL: "🍎", category: "Fruits"),
            Product(name: "Milk", description: "Fresh milk", price: 200, imageURL: "🥛", category: "Dairy")
        ]
        viewModel.selectedCategory = "All"

        XCTAssertEqual(viewModel.filteredProducts.count, 2, "Should show all products when 'All' is selected")
    }

    // MARK: - Test 5: Filtered Products - Specific Category
    func testFilteredProductsByCategory() {
        viewModel.products = [
            Product(name: "Apple", description: "Fresh apple", price: 100, imageURL: "🍎", category: "Fruits"),
            Product(name: "Milk", description: "Fresh milk", price: 200, imageURL: "🥛", category: "Dairy"),
            Product(name: "Banana", description: "Fresh banana", price: 150, imageURL: "🍌", category: "Fruits")
        ]
        viewModel.selectedCategory = "Fruits"

        let filtered = viewModel.filteredProducts
        XCTAssertEqual(filtered.count, 2, "Should show only Fruits products")
        XCTAssertTrue(filtered.allSatisfy { $0.category == "Fruits" }, "All filtered products should be Fruits")
    }

    // MARK: - Test 6: Search by Product Name
    func testSearchByProductName() {
        viewModel.products = [
            Product(name: "Apple", description: "Fresh apple", price: 100, imageURL: "🍎", category: "Fruits"),
            Product(name: "Milk", description: "Fresh milk", price: 200, imageURL: "🥛", category: "Dairy"),
            Product(name: "Banana", description: "Fresh banana", price: 150, imageURL: "🍌", category: "Fruits")
        ]
        viewModel.searchText = "Apple"

        let filtered = viewModel.filteredProducts
        XCTAssertEqual(filtered.count, 1, "Should find one product matching 'Apple'")
        XCTAssertEqual(filtered.first?.name, "Apple", "Found product should be Apple")
    }

    // MARK: - Test 7: Case Insensitive Search
    func testCaseInsensitiveSearch() {
        viewModel.products = [
            Product(name: "Apple", description: "Fresh apple", price: 100, imageURL: "🍎", category: "Fruits"),
            Product(name: "Milk", description: "Fresh milk", price: 200, imageURL: "🥛", category: "Dairy")
        ]
        viewModel.searchText = "apple"

        let filtered = viewModel.filteredProducts
        XCTAssertEqual(filtered.count, 1, "Search should be case insensitive")
        XCTAssertEqual(filtered.first?.name, "Apple", "Should find Apple with lowercase search")
    }

    // MARK: - Test 8: Search by Description
    func testSearchByDescription() {
        viewModel.products = [
            Product(name: "Apple", description: "Fresh organic apple", price: 100, imageURL: "🍎", category: "Fruits"),
            Product(name: "Milk", description: "Fresh milk", price: 200, imageURL: "🥛", category: "Dairy")
        ]
        viewModel.searchText = "organic"

        let filtered = viewModel.filteredProducts
        XCTAssertEqual(filtered.count, 1, "Should find product by description")
        XCTAssertEqual(filtered.first?.name, "Apple", "Should find Apple by description")
    }

    // MARK: - Test 9: Combined Filter - Category and Search
    func testCombinedCategoryAndSearch() {
        viewModel.products = [
            Product(name: "Red Apple", description: "Fresh apple", price: 100, imageURL: "🍎", category: "Fruits"),
            Product(name: "Green Apple", description: "Organic apple", price: 120, imageURL: "🍏", category: "Fruits"),
            Product(name: "Milk", description: "Fresh milk", price: 200, imageURL: "🥛", category: "Dairy")
        ]
        viewModel.selectedCategory = "Fruits"
        viewModel.searchText = "Red"

        let filtered = viewModel.filteredProducts
        XCTAssertEqual(filtered.count, 1, "Should filter by both category and search")
        XCTAssertEqual(filtered.first?.name, "Red Apple", "Should find only Red Apple")
    }

    // MARK: - Test 10: Get Cart Quantity
    func testGetCartQuantityForProduct() {
        let product = Product(name: "Apple", description: "Fresh apple", price: 100, imageURL: "🍎", category: "Fruits")

        // Initially should be 0
        let initialQuantity = viewModel.getCartQuantity(for: product)
        XCTAssertEqual(initialQuantity, 0, "Cart quantity should be 0 initially")

        // Add to cart
        viewModel.addToCart(product)
        let afterAddQuantity = viewModel.getCartQuantity(for: product)
        XCTAssertEqual(afterAddQuantity, 1, "Cart quantity should be 1 after adding")

        // Add again
        viewModel.addToCart(product)
        let afterSecondAddQuantity = viewModel.getCartQuantity(for: product)
        XCTAssertEqual(afterSecondAddQuantity, 2, "Cart quantity should be 2 after adding twice")
    }
}
