//
//  ProductService.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/12.
//

import Foundation

enum ProductError: Error, LocalizedError {
    case invalidURL
    case networkError
    case decodingError
    case noData

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .networkError:
            return "Network connection failed. Please try again."
        case .decodingError:
            return "Failed to parse product data"
        case .noData:
            return "No products available"
        }
    }
}

struct ProductsResponse: Codable {
    let products: [Product]
}

class ProductService {
    static let shared = ProductService()

    private init() {}

    private let apiURL = "https://raw.githubusercontent.com/Rakesh2797/SuperPay/refs/heads/main/products.json"

    /// Fetches products from GitHub-hosted JSON file
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: apiURL) else {
            throw ProductError.invalidURL
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            // Check HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw ProductError.networkError
            }

            // Decode JSON
            let decoder = JSONDecoder()
            let productsResponse = try decoder.decode(ProductsResponse.self, from: data)

            guard !productsResponse.products.isEmpty else {
                throw ProductError.noData
            }

            return productsResponse.products

        } catch let error as ProductError {
            throw error
        } catch is DecodingError {
            throw ProductError.decodingError
        } catch {
            throw ProductError.networkError
        }
    }
}
