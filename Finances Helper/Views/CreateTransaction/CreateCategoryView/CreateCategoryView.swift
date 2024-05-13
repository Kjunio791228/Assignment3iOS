// Imports SwiftUI framework
import SwiftUI

// Defines a SwiftUI view for creating a category
struct CreateCategoryView: View {
    // Defines properties
    let viewType: CreateCategoryViewType
    @ObservedObject var rootVM: RootViewModel
    @ObservedObject var createVM: CreateTransactionViewModel
    @State var colors = (1...10).map({_ in Color.random})
    @FocusState private var isFocused: Bool
    
    // Body of the view
    var body: some View {
        VStack(spacing: 32) {
            // Header view
            headerView
            
            VStack {
                TextField("Title", text: $createVM.categoryTitle)
                    .focused($isFocused)
                Divider()
            }
            
            // Horizontal ScrollView for selecting category color
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    // Iterates over colors to display circles
                    ForEach(colors, id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 30, height: 30)
                            .scaleEffect(color == createVM.categoryColor ? 1.2 : 1)
                            .opacity(color == createVM.categoryColor ? 1 : 0.5)
                            .onTapGesture {
                                createVM.categoryColor = color
                            }
                    }
                }
                .padding(.horizontal, 16)
            }
            .frame(height: 50)
            .padding(.horizontal, -16)
            .onAppear {
                if let color = colors.first {
                    createVM.categoryColor = color
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02){
                    isFocused = true
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
}

// Preview provider for CreateCategoryView
struct CreateCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.secondary
            CreateCategoryView(viewType: .new(isSub: true), rootVM: RootViewModel(context: dev.viewContext), createVM: CreateTransactionViewModel(context: dev.viewContext, transactionType: .expense))
                .padding()
        }
    }
}

// Extension for CreateCategoryView
extension CreateCategoryView {
    // Header view with buttons and title
    private var headerView: some View {
        HStack {
            // Button to dismiss the view
            Button {
                isFocused = false
                createVM.createCategoryViewType = nil
            } label: {
                Image(systemName: "xmark")
            }
            Spacer()
            // Title of the view
            Text(viewType.navTitle)
                .font(.headline.bold())
            Spacer()
            // Button to add category or subcategory
            Button {
                isFocused = false
                switch viewType {
                case .new(let isSubcategory):
                    if isSubcategory {
                        createVM.addSubcategory()
                    } else {
                        createVM.addCategory()
                    }
                case .edit:
                    break
                }
            } label: {
                Image(systemName: "checkmark")
            }
            .disabled(createVM.categoryTitle.isEmpty)
        }
    }
}

// Enum to represent the type of CreateCategoryView
enum CreateCategoryViewType: Identifiable, Equatable {
    case new(isSub: Bool)
    case edit(isSub: Bool, CategoryEntity)
    
    // ID for Identifiable protocol
    var id: Int {
        switch self {
        case .new: return 0
        case .edit: return 1
        }
    }
    
    // Title for the navigation bar
    var navTitle: String {
        switch self {
        case .new(let isSub):
            return "New \(isSub ? "subcategory" : "category")"
        case .edit(let isSub, _):
            return "Edit \(isSub ? "subcategory" : "category")"
        }
    }
}
