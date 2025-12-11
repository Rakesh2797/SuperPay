//
//  CheckoutView.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/12.
//

import SwiftUI

struct CheckoutView: View {
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = CheckoutViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showPaymentResult = false
    @State private var rotationDegrees: Double = 0

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

            contentView
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(red: 0.3, green: 0.5, blue: 0.85), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationBarBackButtonHidden(viewModel.checkoutState == .processing)
        .sheet(isPresented: $showPaymentResult) {
            PaymentResultView(
                checkoutState: viewModel.checkoutState,
                onTryAgain: {
                    showPaymentResult = false
                    rotationDegrees = 0
                    viewModel.reset()
                },
                onDismiss: {
                    // On dismiss - pop to root (home screen) by clearing the navigation path
                    if case .success = viewModel.checkoutState {
                        navigationPath.removeLast(navigationPath.count)
                    }
                }
            )
        }
        .onChange(of: viewModel.checkoutState) { oldValue, newValue in
            switch newValue {
            case .success, .error:
                showPaymentResult = true
            default:
                break
            }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.checkoutState {
        case .idle:
            checkoutFormView
        case .processing:
            processingView
        case .success, .error:
            // Show sheet
            checkoutFormView
        }
    }

    private var checkoutFormView: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Wallet section
                walletSection

                // Order summary
                orderSummarySection

                // Items list
                itemsSection

                // Payment button
                paymentButton
            }
            .padding()
        }
    }

    private var walletSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "wallet.pass.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Wallet Balance")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))

                    Text("¥\(String(format: "%.0f", viewModel.walletBalance))")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }

                Spacer()

                if viewModel.walletBalance >= viewModel.totalAmount {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.3, green: 0.5, blue: 0.85).opacity(0.6),
                                Color(red: 0.4, green: 0.6, blue: 0.9).opacity(0.6)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )

            if viewModel.walletBalance < viewModel.totalAmount {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.red)
                    Text("Insufficient funds. Please add money to your wallet.")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
            }
        }
    }

    private var orderSummarySection: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Order Summary")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()
            }
            .padding()
            .background(
                Color(red: 0.3, green: 0.5, blue: 0.85).opacity(0.7)
            )

            // Details
            VStack(spacing: 12) {
                summaryRow(label: "Subtotal", value: viewModel.totalAmount)
                summaryRow(label: "Tax", value: 0.0)
                summaryRow(label: "Delivery", value: 0.0, note: "FREE")

                Divider()
                    .background(Color.white.opacity(0.5))

                HStack {
                    Text("Total")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Spacer()

                    Text("¥\(String(format: "%.0f", viewModel.totalAmount))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(
                Color(red: 0.4, green: 0.6, blue: 0.9).opacity(0.5)
            )
        }
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }

    private func summaryRow(label: String, value: Double, note: String? = nil) -> some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))

            Spacer()

            if let note = note {
                Text(note)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white.opacity(0.9))
                    )
            } else {
                Text("¥\(String(format: "%.0f", value))")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
        }
    }

    private var itemsSection: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Items (\(viewModel.items.count))")
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()
            }
            .padding()
            .background(
                Color(red: 0.3, green: 0.5, blue: 0.85).opacity(0.7)
            )

            // Items list
            VStack(spacing: 12) {
                ForEach(viewModel.items) { item in
                    CheckoutItemRow(item: item)
                }
            }
            .padding()
            .background(
                Color(red: 0.4, green: 0.6, blue: 0.9).opacity(0.5)
            )
        }
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }

    private var paymentButton: some View {
        VStack(spacing: 12) {
            Button(action: {
                viewModel.processPayment()
            }) {
                HStack {
                    Image(systemName: "lock.fill")
                    Text("Confirm Payment")
                        .font(.headline)
                    Spacer()
                    Text("¥\(String(format: "%.0f", viewModel.totalAmount))")
                        .font(.headline)
                        .fontWeight(.bold)
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
            .disabled(!viewModel.canProceedToPayment)
            .opacity(viewModel.canProceedToPayment ? 1.0 : 0.6)

            Text("Secure payment powered by SuperPay")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
    }

    private var processingView: some View {
        VStack(spacing: 32) {
            // Animated loading indicator
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 8)
                    .frame(width: 120, height: 120)

                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color(red: 0.2, green: 0.4, blue: 0.8),
                                Color.white
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(rotationDegrees))

                Image(systemName: "creditcard.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            .onAppear {
                withAnimation(
                    Animation.linear(duration: 1.5)
                        .repeatForever(autoreverses: false)
                ) {
                    rotationDegrees = 360
                }
            }

            VStack(spacing: 12) {
                Text("Processing Payment")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Please wait while we confirm your payment...")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)

                Text("¥\(String(format: "%.0f", viewModel.totalAmount))")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 8)
            }

            // Processing steps
            VStack(alignment: .leading, spacing: 16) {
                ProcessingStep(title: "Verifying payment details", isActive: true)
                ProcessingStep(title: "Confirming with bank", isActive: true)
                ProcessingStep(title: "Securing transaction", isActive: true)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.1))
            )
        }
        .padding()
    }
}

// MARK: - Checkout Item Row
struct CheckoutItemRow: View {
    let item: CartItem

    var body: some View {
        HStack(spacing: 12) {
            Text(item.product.imageURL)
                .font(.system(size: 32))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.product.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("Qty: \(item.quantity)")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
            }

            Spacer()

            Text("¥\(String(format: "%.0f", item.totalPrice))")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Processing Step
struct ProcessingStep: View {
    let title: String
    let isActive: Bool

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 24, height: 24)

                if isActive {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.7)
                }
            }

            Text(title)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))

            Spacer()
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack(path: $path) {
        CheckoutView(navigationPath: $path)
    }
}
