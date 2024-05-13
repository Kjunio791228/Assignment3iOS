//  CategoryEntity.swift
//  Finances Helper
//
//  Created by Kendrick  on 10/05/24.
//

// Defines extensions for CategoryEntity

// Imports necessary frameworks
import Foundation
import CoreData
import SwiftUI

// Extension for CategoryEntity
extension CategoryEntity {
  
    // Computed property to get and set category type
    var wrappedCategoryType: TransactionType {
        get { TransactionType(rawValue: type ?? "") ?? .expense }
        set { type = newValue.rawValue }
    }

    // Computed property to get and set subcategories
    var wrappedSubcategories: Set<CategoryEntity> {
        get { (subcategories as? Set<CategoryEntity>) ?? [] }
        set { subcategories = newValue as NSSet }
    }
    
    // Computed property to get color as SwiftUI Color
    var wrappedColor: Color {
        guard let color else { return .blue }
        return Color(hex: color)
    }
    
    // Static method to create a fetch request for CategoryEntity
    static func request() -> NSFetchRequest<CategoryEntity> {
        let fetchRequest = NSFetchRequest<CategoryEntity>(entityName: "CategoryEntity")
        fetchRequest.predicate = NSPredicate(format: "isParent == YES")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createAt", ascending: true)]
        return fetchRequest
    }
    
    // Static method to create a CategoryEntity
    @discardableResult
    static func create(
        context: NSManagedObjectContext,
        title: String,
        color: String?,
        subcategories: Set<CategoryEntity>?,
        isParent: Bool,
        type: TransactionType
    ) -> CategoryEntity {
        let category = CategoryEntity(context: context)
        category.id = UUID().uuidString
        category.createAt = Date.now
        category.color = color
        category.title = title
        category.isParent = isParent
        category.wrappedCategoryType = type
        if let subcategories {
            category.wrappedSubcategories = subcategories
        }
        
        return category
    }
}
