# SuperPay

A modern iOS e-commerce application built with SwiftUI, featuring a digital wallet system and seamless checkout experience.
Please check the demo video for the app implementation.

## Technical Overview

SuperPay is a native iOS application that demonstrates modern iOS development patterns using SwiftUI, Combine framework, and MVVM architecture. The app provides a complete shopping experience with real-time cart management, integrated wallet functionality, and transaction history.

## Architecture

### MVVM Pattern
- **Models**: `Product`, `CartItem`, `Transaction`
- **ViewModels**: `ProductListViewModel`, `CheckoutViewModel`, `WalletViewModel`
- **Views**: `ProductListView`, `CartView`, `CheckoutView`, `WalletView`, `PaymentResultView`

### State Management
- **Singleton Pattern**: `CartManager` and `ProductService` for centralized state
- **Combine Framework**: `@Published` properties for reactive UI updates
- **ObservableObject**: View models conform to ObservableObject for SwiftUI bindings

### Data Persistence
- **UserDefaults**: Local storage for cart items, wallet balance, and transaction history
- **JSON Encoding/Decoding**: Codable protocol for data serialization

## Core Features

### Product Catalog
- Dynamic product loading from JSON API
- Category-based filtering with 10+ categories
- Real-time search across product name, description, and category
- Emoji-based product imagery

### Shopping Cart
- Add/remove items with quantity management
- Real-time cart total calculation
- Persistent cart state across app launches
- Floating cart button with item count and total amount

### Digital Wallet
- Virtual wallet with initial balance (¥150,000)
- Top-up functionality with predefined amounts
- Balance tracking and persistence
- Insufficient funds validation

### Checkout & Payments
- Multi-step checkout flow with validation
- OTP-based payment authorization (4-digit)
- Transaction ID generation
- Success/failure handling with appropriate UI feedback

### Transaction History
- Chronological transaction list
- Detailed transaction view with item breakdown
- Support for both purchase and top-up transactions
- Date formatting with relative time display

## Technical Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Architecture**: MVVM
- **Reactive Programming**: Combine
- **Async/Await**: Modern concurrency for network calls
- **Persistence**: UserDefaults with Codable
- **Testing**: XCTest with unit tests for ViewModels

## Project Structure

```
SuperPay/
├── Models/
│   ├── Product.swift          # Product data model with mock data
│   ├── CartItem.swift          # Cart item with quantity tracking
│   └── Transaction.swift       # Transaction history model
├── ViewModels/
│   ├── ProductListViewModel.swift    # Product list logic & filtering
│   ├── CheckoutViewModel.swift       # Checkout flow management
│   └── WalletViewModel.swift         # Wallet operations
├── Views/
│   ├── ProductListView.swift         # Main product catalog
│   ├── CartView.swift                # Shopping cart interface
│   ├── CheckoutView.swift            # Multi-step checkout
│   ├── WalletView.swift              # Wallet management
│   ├── PaymentResultView.swift       # Transaction result
│   └── TransactionDetailView.swift   # Transaction details
├── Managers/
│   └── CartManager.swift       # Centralized cart & wallet state
└── Services/
    ├── ProductService.swift    # API integration for products
    └── CheckoutService.swift   # Checkout processing
```

## Key Components

### CartManager (Singleton)
Manages global cart state, wallet balance, and transaction history. Provides thread-safe access to shared state with automatic persistence.

### LoadingState Enum
```swift
enum LoadingState {
    case idle
    case loading
    case success
    case error(String)
}
```
Handles asynchronous operation states for better UX.

### ProductService
RESTful API integration using async/await pattern with proper error handling:
- `ProductError`: Custom error types with localized descriptions
- Network layer with URLSession
- JSON decoding with error recovery

## UI/UX Features

- **Gradient Backgrounds**: LinearGradient-based theme (blue palette)
- **Animations**: Spring animations for cart interactions, transitions
- **Haptic Feedback**: UIImpactFeedbackGenerator for tactile responses
- **Navigation**: NavigationStack with programmatic navigation
- **Pull-to-Refresh**: SwiftUI refreshable modifier
- **Empty States**: Contextual empty state views
- **Loading States**: ProgressView with messaging

## Testing

Unit tests for ViewModels covering:
- Initial state validation
- Filtering logic (category & search)
- Cart quantity tracking
- Combined filter scenarios
- Case-insensitive search

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

