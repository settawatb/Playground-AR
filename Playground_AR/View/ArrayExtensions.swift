//
//  ArrayExtensions.swift
//  Playground_AR
//
//  Created by Settawat Buddhakanchana on 18/2/2567 BE.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
