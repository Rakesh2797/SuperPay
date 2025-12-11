//
//  Product.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/09.
//

import Foundation

struct Product: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let imageURL: String
    let category: String

    init(id: String = UUID().uuidString, name: String, description: String, price: Double, imageURL: String, category: String) {
        self.id = id
        self.name = name
        self.description = description
        self.price = price
        self.imageURL = imageURL
        self.category = category
    }
}

extension Product {
    static let mockProducts: [Product] = [
        Product(
            name: "Fresh Apples",
            description: "Organic red apples, sweet and crispy",
            price: 750,
            imageURL: "🍎",
            category: "Fruits"
        ),
        Product(
            name: "Whole Milk",
            description: "Farm fresh whole milk, 1 gallon",
            price: 820,
            imageURL: "🥛",
            category: "Dairy"
        ),
        Product(
            name: "Sourdough Bread",
            description: "Artisan sourdough bread, freshly baked",
            price: 1050,
            imageURL: "🍞",
            category: "Bakery"
        ),
        Product(
            name: "Bananas",
            description: "Ripe yellow bananas, bunch of 6",
            price: 520,
            imageURL: "🍌",
            category: "Fruits"
        ),
        Product(
            name: "Ground Coffee",
            description: "Premium arabica coffee beans, 12oz",
            price: 1950,
            imageURL: "☕️",
            category: "Beverages"
        ),
        Product(
            name: "Eggs",
            description: "Free-range eggs, dozen",
            price: 1200,
            imageURL: "🥚",
            category: "Dairy"
        ),
        Product(
            name: "Orange Juice",
            description: "Freshly squeezed orange juice, 64oz",
            price: 1270,
            imageURL: "🍊",
            category: "Beverages"
        ),
        Product(
            name: "Cheddar Cheese",
            description: "Aged cheddar cheese block, 8oz",
            price: 1500,
            imageURL: "🧀",
            category: "Dairy"
        ),
        Product(
            name: "Cherry Tomatoes",
            description: "Sweet cherry tomatoes, 1lb container",
            price: 900,
            imageURL: "🍅",
            category: "Vegetables"
        ),
        Product(
            name: "Pasta",
            description: "Italian spaghetti pasta, 16oz",
            price: 600,
            imageURL: "🍝",
            category: "Pantry"
        ),
        Product(
            name: "Strawberries",
            description: "Fresh strawberries, 16oz pack",
            price: 970,
            imageURL: "🍓",
            category: "Fruits"
        ),
        Product(
            name: "Chicken Breast",
            description: "Boneless chicken breast, 1lb",
            price: 1800,
            imageURL: "🍗",
            category: "Meat"
        ),
        Product(
            name: "Broccoli",
            description: "Fresh broccoli crowns, 1lb",
            price: 680,
            imageURL: "🥦",
            category: "Vegetables"
        ),
        Product(
            name: "Carrots",
            description: "Organic baby carrots, 2lb bag",
            price: 550,
            imageURL: "🥕",
            category: "Vegetables"
        ),
        Product(
            name: "Avocado",
            description: "Ripe Hass avocados, pack of 4",
            price: 1100,
            imageURL: "🥑",
            category: "Fruits"
        ),
        Product(
            name: "Grapes",
            description: "Seedless red grapes, 2lb bag",
            price: 850,
            imageURL: "🍇",
            category: "Fruits"
        ),
        Product(
            name: "Watermelon",
            description: "Sweet seedless watermelon, whole",
            price: 1350,
            imageURL: "🍉",
            category: "Fruits"
        ),
        Product(
            name: "Yogurt",
            description: "Greek yogurt, vanilla flavor, 32oz",
            price: 950,
            imageURL: "🥛",
            category: "Dairy"
        ),
        Product(
            name: "Butter",
            description: "Salted butter, 1lb package",
            price: 880,
            imageURL: "🧈",
            category: "Dairy"
        ),
        Product(
            name: "Croissants",
            description: "French butter croissants, pack of 6",
            price: 1450,
            imageURL: "🥐",
            category: "Bakery"
        ),
        Product(
            name: "Bagels",
            description: "Plain bagels, pack of 6",
            price: 780,
            imageURL: "🥯",
            category: "Bakery"
        ),
        Product(
            name: "Donuts",
            description: "Assorted glazed donuts, box of 12",
            price: 1650,
            imageURL: "🍩",
            category: "Bakery"
        ),
        Product(
            name: "Green Tea",
            description: "Organic green tea bags, 20 count",
            price: 720,
            imageURL: "🍵",
            category: "Beverages"
        ),
        Product(
            name: "Lemon Water",
            description: "Sparkling lemon water, 6-pack",
            price: 890,
            imageURL: "🍋",
            category: "Beverages"
        ),
        Product(
            name: "Rice",
            description: "Premium jasmine rice, 5lb bag",
            price: 1550,
            imageURL: "🍚",
            category: "Pantry"
        ),
        Product(
            name: "Olive Oil",
            description: "Extra virgin olive oil, 750ml",
            price: 2100,
            imageURL: "🫒",
            category: "Pantry"
        ),
        Product(
            name: "Peanut Butter",
            description: "Creamy peanut butter, 16oz jar",
            price: 820,
            imageURL: "🥜",
            category: "Pantry"
        ),
        Product(
            name: "Honey",
            description: "Pure organic honey, 12oz bottle",
            price: 1280,
            imageURL: "🍯",
            category: "Pantry"
        ),
        Product(
            name: "Salmon Fillet",
            description: "Fresh Atlantic salmon, 1lb",
            price: 2850,
            imageURL: "🐟",
            category: "Meat"
        ),
        Product(
            name: "Ground Beef",
            description: "85/15 ground beef, 1lb",
            price: 1950,
            imageURL: "🥩",
            category: "Meat"
        ),
        Product(
            name: "Bacon",
            description: "Hickory smoked bacon, 12oz",
            price: 1350,
            imageURL: "🥓",
            category: "Meat"
        ),
        Product(
            name: "Bell Peppers",
            description: "Mixed bell peppers, pack of 3",
            price: 720,
            imageURL: "🫑",
            category: "Vegetables"
        ),
        Product(
            name: "Potatoes",
            description: "Russet potatoes, 5lb bag",
            price: 650,
            imageURL: "🥔",
            category: "Vegetables"
        ),
        Product(
            name: "Onions",
            description: "Yellow onions, 3lb bag",
            price: 480,
            imageURL: "🧅",
            category: "Vegetables"
        ),
        Product(
            name: "Mushrooms",
            description: "Fresh button mushrooms, 8oz",
            price: 720,
            imageURL: "🍄",
            category: "Vegetables"
        ),
        Product(
            name: "Ice Cream",
            description: "Vanilla ice cream, 1.5 quart",
            price: 1180,
            imageURL: "🍦",
            category: "Dairy"
        )
    ]
}
