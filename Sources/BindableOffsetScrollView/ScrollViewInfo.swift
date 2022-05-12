//
//  ScrollViewInfo.swift
//  
//
//  Created by Franklyn Weber on 16/03/2021.
//

import UIKit


public struct ScrollViewInfo: Equatable {
    public let offset: CGFloat
    public let size: CGSize
    public let contentSize: CGSize
    
    public init(offset: CGFloat, size: CGSize, contentSize: CGSize) {
        self.offset = offset
        self.size = size
        self.contentSize = contentSize
    }
}
