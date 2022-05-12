//
//  ScrollViewOffsetPreferenceKey.swift
//  
//
//  Created by Franklyn Weber on 16/03/2021.
//

import SwiftUI


struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    
    typealias Value = [ScrollViewInfo]
    
    static var defaultValue: [ScrollViewInfo] = [ScrollViewInfo(offset: 0, size: .zero, contentSize: .zero)]
    
    static func reduce(value: inout [ScrollViewInfo], nextValue: () -> [ScrollViewInfo]) {
        value.append(contentsOf: nextValue())
    }
}
