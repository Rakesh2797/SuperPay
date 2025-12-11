//
//  PaymentResultView.swift
//  SuperPay
//
//  Created by Kota Rakesh on 2025/12/12.
//

import SwiftUI

struct PaymentResultView: View {
    let checkoutState: CheckoutState
    let onTryAgain: () -> Void
    let onDismiss: () -> Void

    @Environment(\.dismiss) var dismiss
    @State private var animateSuccess = false
    @State private var animateError = false

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

            switch checkoutState {
            case .success(let response):
                successView(response: response)
            case .error(let message):
                errorView(message: message)
            default:
                EmptyView()
            }
        }
        .onAppear {
            if case .success = checkoutState {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                    animateSuccess = true
                }
            } else if case .error = checkoutState {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                    animateError = true
                }
            }
        }
    }

    private func successView(response: CheckoutResponse) -> some View {
        VStack(spacing: 32) {
            Spacer()

            // Success icon with animation
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 150, height: 150)
                    .scaleEffect(animateSuccess ? 1.0 : 0.5)
                    .opacity(animateSuccess ? 1.0 : 0.0)

                Circle()
                    .fill(Color.green)
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateSuccess ? 1.0 : 0.5)
                    .opacity(animateSuccess ? 1.0 : 0.0)

                Image(systemName: "checkmark")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(animateSuccess ? 1.0 : 0.5)
                    .opacity(animateSuccess ? 1.0 : 0.0)
            }

            // Success message
            VStack(spacing: 16) {
                Text("Payment Successful!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(animateSuccess ? 1.0 : 0.0)
                    .offset(y: animateSuccess ? 0 : 20)

                Text(response.message)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(animateSuccess ? 1.0 : 0.0)
                    .offset(y: animateSuccess ? 0 : 20)

                // Transaction details
                VStack(spacing: 12) {
                    DetailRow(
                        icon: "number",
                        label: "Transaction ID",
                        value: response.transactionId
                    )

                    DetailRow(
                        icon: "dollarsign.circle.fill",
                        label: "Remaining Balance",
                        value: "¥\(String(format: "%.0f", response.remainingBalance))"
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.2))
                )
                .opacity(animateSuccess ? 1.0 : 0.0)
                .offset(y: animateSuccess ? 0 : 20)
            }
            .padding(.horizontal)

            Spacer()

            // Action button
            Button(action: {
                dismiss()
                onDismiss()
            }) {
                Text("Done")
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
            .padding()
            .opacity(animateSuccess ? 1.0 : 0.0)
            .offset(y: animateSuccess ? 0 : 20)
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 32) {
            Spacer()

            // Error icon with animation
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 150, height: 150)
                    .scaleEffect(animateError ? 1.0 : 0.5)
                    .opacity(animateError ? 1.0 : 0.0)

                Circle()
                    .fill(Color.red)
                    .frame(width: 120, height: 120)
                    .scaleEffect(animateError ? 1.0 : 0.5)
                    .opacity(animateError ? 1.0 : 0.0)

                Image(systemName: "xmark")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(animateError ? 1.0 : 0.5)
                    .opacity(animateError ? 1.0 : 0.0)
            }

            // Error message
            VStack(spacing: 16) {
                Text("Payment Failed")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(animateError ? 1.0 : 0.0)
                    .offset(y: animateError ? 0 : 20)

                Text(message)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .opacity(animateError ? 1.0 : 0.0)
                    .offset(y: animateError ? 0 : 20)

                // Error info card
                HStack(spacing: 12) {
                    Image(systemName: "info.circle.fill")
                        .font(.title2)
                        .foregroundColor(.white)

                    Text("Your items are still in the cart. Please try again or contact support.")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.2))
                )
                .opacity(animateError ? 1.0 : 0.0)
                .offset(y: animateError ? 0 : 20)
            }
            .padding(.horizontal)

            Spacer()

            // Action buttons
            VStack(spacing: 12) {
                Button(action: {
                    dismiss()
                    onTryAgain()
                }) {
                    Text("Try Again")
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

                Button(action: {
                    dismiss()
                    onDismiss()
                }) {
                    Text("Back to Cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
            }
            .padding()
            .opacity(animateError ? 1.0 : 0.0)
            .offset(y: animateError ? 0 : 20)
        }
    }
}

// MARK: - Detail Row
struct DetailRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white.opacity(0.8))
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))

                Text(value)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }

            Spacer()
        }
    }
}

#Preview("Success") {
    PaymentResultView(
        checkoutState: .success(
            CheckoutResponse(
                success: true,
                transactionId: "TXN-1234567890-5678",
                message: "Payment successful!",
                remainingBalance: 900.50
            )
        ),
        onTryAgain: {},
        onDismiss: {}
    )
}

#Preview("Error") {
    PaymentResultView(
        checkoutState: .error("Network connection failed. Please try again."),
        onTryAgain: {},
        onDismiss: {}
    )
}
