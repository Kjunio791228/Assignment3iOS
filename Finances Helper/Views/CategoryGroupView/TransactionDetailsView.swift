// TransactionDetailsView.swift
// Finances Helper
//
// Created by Kendrick on 10/05/24.

import SwiftUI

// Define a SwiftUI view called TransactionDetailsView
struct TransactionDetailsView: View {
    @Environment(\.dismiss) private var dismiss // Environment variable to dismiss the view
    @ObservedObject var transaction: TransactionEntity // Transaction entity to display details
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            // Display labels and corresponding values for transaction details
            labelView(title: "Amount", value: transaction.friendlyAmount)
            labelView(title: "Creator", value: transaction.created?.name ?? "")
            labelView(title: "Category", value: transaction.category?.title ?? "No category")
            labelView(title: "Date", value: transaction.createAt?.formatted(date: .abbreviated, time: .omitted) ?? "")
            labelView(title: "Note", value: transaction.note ?? "")
            Spacer() // Spacer to push views to the top
        }
        .hLeading() // Align the VStack leading edge
        .padding() // Add padding around the content
        .toolbar {
            // Set the title in the toolbar
            ToolbarItem(placement: .principal) {
                Text("Transaction details")
            }
            
            // Add a button to delete the transaction
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    TransactionEntity.remove(transaction)
                    dismiss() // Dismiss the view after deleting the transaction
                } label: {
                    Image(systemName: "trash") // Trash icon
                        .foregroundColor(.red) // Make the icon red
                }
            }
        }
    }
}

// Preview provider for TransactionDetailsView
struct TransactionDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TransactionDetailsView(transaction: dev.transactions.first!)
        }
    }
}

extension TransactionDetailsView {
    // Function to create a label view with a title and value
    private func labelView(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title) // Display the title
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value) // Display the corresponding value
                .font(.headline.weight(.medium))
        }
    }
}
