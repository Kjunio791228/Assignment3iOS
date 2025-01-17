//
//  TransactionsListView.swift
//  Finances Helper
//
//  Created by Jaipreet  on 10/05/24.
//

import SwiftUI

struct TransactionsListView: View {
    @ObservedObject var rootVM: RootViewModel
    var chartData: [ChartData]
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            ForEach(chartData) { group in
                
                NavigationLink {
                    CategoryGroupView(chartData: group, rootVM: rootVM)
                } label: {
                    HStack(spacing: 20){
                        Text(group.title)
                            .font(.subheadline.weight(.medium))
                            .lineLimit(1)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(group.color, in: Capsule())
                        Spacer()
                        Text("\(Int(group.percentage * 100))%")
                            .foregroundColor(.secondary)
                        Text(group.friendlyTotal)
                            .foregroundColor(.black)
                            .font(.headline)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 5)
                }
            }
        }
    }
}

struct TarnsactionListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TransactionsListView(rootVM: RootViewModel(context: dev.viewContext), chartData: ChartData.sample)
        }
        .environmentObject(RootViewModel(context: dev.viewContext))
    }
}
