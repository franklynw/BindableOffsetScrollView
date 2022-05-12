//
//  BindableOffsetScrollView+Modifiers.swift
//  
//
//  Created by Franklyn Weber on 16/03/2021.
//

import SwiftUI


extension BindableOffsetScrollView {
    
    /// Invokes the passed-in closure if the user pulls up the content by a specified amount beyond the bottom
    /// - Parameters:
    ///   - offset: the extra amount to pull up before the closure is invoked - defaults to 50 px
    ///   - perform: the closure to invoke
    public func loadMore(onPullUpOffset offset: CGFloat = 50, perform: @escaping () -> ()) -> Self {
        var copy = self
        copy.loadMoreOffset = offset
        copy.loadMore = perform
        return copy
    }
}
