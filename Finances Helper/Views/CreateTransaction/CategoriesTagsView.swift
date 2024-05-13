// CategoriesTagsView.swift
// Finances Helper
//
// Created by Kendrick on 10/05/24.

import SwiftUI

// SwiftUI view for displaying categories and subcategories
struct CategoriesTagsView: View {
    @ObservedObject var createVM: CreateTransactionViewModel // View model for creating transactions

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Category") // Title for category section
                .font(.title3.bold())
            if let selectedCategory = createVM.selectedCategory {
                // Display selected category
                tagView(selectedCategory, isSubcategory: false)
                Text("Subcategory") // Title for subcategory section
                    .font(.title3.bold())
                // Display subcategories for the selected category
                tagsList(Array(selectedCategory.wrappedSubcategories), isSubcategory: true)
            } else {
                // Display available categories based on transaction type
                tagsList(createVM.categories.filter({$0.wrappedCategoryType == createVM.transactionType}), isSubcategory: false)
            }
        }
        .hLeading() // Align content leading edge
    }
}

// Preview provider for CategoriesTagsView
struct CategoryTagView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesTagsView(createVM: CreateTransactionViewModel(context: dev.viewContext, transactionType: .expense))
            .padding()
    }
}

// Extension to CategoriesTagsView for private functions
extension CategoriesTagsView {

    // View for displaying a category or subcategory tag
    private func tagView(_ category: CategoryEntity, isSubcategory: Bool) -> some View {
        Text(category.title ?? "") // Display category title
            .foregroundColor(.white)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(category.wrappedColor, in: Capsule()) // Background color for the tag
            .opacity(isSubcategory ? (category.id == createVM.selectedSubCategoryId ? 1 : 0.5) : 1) // Adjust opacity for subcategories
            .onTapGesture {
                // Toggle selection of category or subcategory on tap
                if isSubcategory {
                    createVM.toggleSelectSubcategory(category.id ?? "")
                } else {
                    createVM.toggleSelectCategory(category)
                }
            }
    }
    
    // View for displaying a list of tags (categories or subcategories)
    private func tagsList(_ categories: [CategoryEntity], isSubcategory: Bool) -> some View {
        TagLayout(alignment: .leading) {
            // Loop through categories/subcategories and display tags
            ForEach(categories) { category in
                tagView(category, isSubcategory: isSubcategory)
            }
            // Button for adding a new category or subcategory
            Button {
                createVM.createCategoryViewType = .new(isSub: isSubcategory)
            } label: {
                Label("New", systemImage: "plus")
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(Color.secondary, in: Capsule()) // Background color for the "New" button
            }
        }
    }
}
