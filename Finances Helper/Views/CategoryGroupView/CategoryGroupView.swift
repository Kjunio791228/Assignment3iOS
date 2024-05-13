// CategoryGroupView.swift
// Finances Helper
//
// Created by Kendrick on 10/05/24.

import SwiftUI

// Define a SwiftUI view called CategoryGroupView
struct CategoryGroupView: View {
    var chartData: ChartData // Data for the chart
    @ObservedObject var rootVM: RootViewModel // View model for root view
    
    // Computed property to get grouped transactions based on current tab and category ID
    var groupedTransactions: [[TransactionEntity]] {
        rootVM.statsData.getTransactions(for: rootVM.currentTab, categoryId: chartData.id)
            .groupTransactionsByDate()
    }
    
    // Computed property to calculate total amount of transactions
    private var total: String {
        groupedTransactions.flatMap({$0}).reduce(0.0, {$0 + $1.amount}).toCurrency(symbol: chartData.cyrrencySymbol)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: 16) {
                    
                    // Loop through grouped transactions
                    ForEach(groupedTransactions.indices, id: \.self) { index in
                        if let date = groupedTransactions[index].first?.createAt?.toFriedlyDate {
                            // Display date for each group
                            Text(date)
                                .font(.subheadline.bold())
                                .foregroundColor(.secondary)
                            
                            // Loop through transactions within each group
                            ForEach(groupedTransactions[index]) { transaction in
                                // Navigate to transaction details view
                                NavigationLink {
                                    TransactionDetailsView(transaction: transaction)
                                } label: {
                                    rowView(transaction)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .toolbar {
            // Display title and total amount in the toolbar
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(chartData.title)
                        .font(.subheadline.bold())
                    Text(total)
                        .font(.title3.bold())
                }
            }
        }
    }
}

// Preview provider for CategoryGroupView
struct CategoryGroupView_Previews: PreviewProvider {
    static let category = dev.category.first!
    static var previews: some View {
        NavigationStack {
            CategoryGroupView(chartData: ChartData(id: category.id ?? "", color: category.wrappedColor, value: 240, title: category.title ?? "", type: category.wrappedCategoryType, cyrrencySymbol: "$"), rootVM: RootViewModel(context: dev.viewContext))
        }
    }
}

extension CategoryGroupView {
    // Function to create a row view for each transaction
    private func rowView(_ transaction: TransactionEntity) -> some View {
        VStack {
            HStack{
                VStack(alignment: .leading) {
                    Text(chartData.title) // Display category title
                    Text(transaction.note ?? "") // Display transaction note
                }
                Spacer()
                Text(transaction.friendlyAmount) // Display transaction amount
                    .font(.headline)
            }
            Divider()
        }
        .foregroundColor(.black)
        .background(Color.white)
    }
}
