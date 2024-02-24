//
//  StaggeredGrid.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 24/12/2566 BE.
//

import SwiftUI

// Custom View Builder

struct StaggeredGrid<Content: View, T: Identifiable>: View where T: Hashable {
    
    var content: (T) -> Content
    var list: [T]
    
    // Columns...
    var columns: Int
    
    // Properties
    var showsIndicators: Bool
    var spacing: CGFloat
    
    init(columns: Int, showsIndicators: Bool = false, spacing: CGFloat = 10, list: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.content = content
        self.list = list
        self.spacing = spacing
        self.showsIndicators = showsIndicators
        self.columns = columns
    }
    
    // Staggered Grid Function
    func setUpList() -> [[T]] {
        // creating empty sub arrays of column count
        var gridArray: [[T]] = Array(repeating: [], count: columns)

        // calculating the average number of objects per column
        _ = list.count / columns

        // distributing objects among columns
        for (index, object) in list.enumerated() {
            let columnIndex = index % columns
            gridArray[columnIndex].append(object)
        }

        return gridArray
    }

    
    var body: some View {
        
        
        
        ScrollView(.vertical, showsIndicators: showsIndicators) {
            HStack(alignment: .top, spacing: 20) {
                
                ForEach(setUpList(),id: \.self){ columnsData in
                    
                    // For Optimized LazyStack
                    LazyVStack(spacing: spacing){
                        
                        ForEach(columnsData) {object in
                            content(object)
                        }
                    }
                }
                
            }
            
            // vertical padding
            .padding(.vertical)
        }
        
    }
}

    
//    struct StaggeredGrid_Previews: 
//        PreviewProvider {
//        static var previews: some View {
//            Home()
//    }
//}
