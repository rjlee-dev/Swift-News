//
//  SwiftExtensions.swift
//  Swift News
//
//  Created by Atomicflare on 2020-10-10.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
