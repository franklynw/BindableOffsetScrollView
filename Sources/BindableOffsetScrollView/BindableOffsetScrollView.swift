//
//  BindableOffsetScrollView.swift
//
//  Created by Franklyn Weber on 29/01/2021
//

import SwiftUI


protocol BoundScrollView {
    var axes: Axis.Set { get }
    var loadMoreOffset: CGFloat? { get }
    var loadMore: (() -> ())? { get }
}


public struct BindableOffsetScrollView<Content>: View, BoundScrollView where Content: View {
    
    let axes: Axis.Set
    
    var loadMoreOffset: CGFloat?
    var loadMore: (() -> ())?
    
    private let showIndicators: Bool
    private let contentWithInfo: ((ScrollViewInfo) -> Content)?
    private let content: (() -> Content)?
    
    @Binding private var scrollViewInfo: ScrollViewInfo
    
    
    public init(axes: Axis.Set = .vertical, showIndicators: Bool = true, @ViewBuilder content: @escaping (ScrollViewInfo) -> Content) {
        self.axes = axes
        self.showIndicators = showIndicators
        self.contentWithInfo = content
        self.content = nil
        _scrollViewInfo = Binding<ScrollViewInfo>(get: { ScrollViewInfo(offset: 0, size: .zero, contentSize: .zero) }, set: { _ in })
    }
    
    public init(axes: Axis.Set = .vertical, showIndicators: Bool = true, scrollViewInfo: Binding<ScrollViewInfo>, @ViewBuilder content: @escaping () -> Content) {
        self.axes = axes
        self.showIndicators = showIndicators
        self.content = content
        contentWithInfo = nil
        _scrollViewInfo = scrollViewInfo
    }
    
    public var body: some View {
        
        GeometryReader { outsideGeometry in
            
            ScrollView(axes, showsIndicators: showIndicators) {
                
                ZStack(alignment: axes == .vertical ? .top : .leading) {
                    
                    GeometryReader { insideGeometry in
                        Color.clear
                            .preference(key: ScrollViewOffsetPreferenceKey.self, value: [calculateOffset(fromOutside: outsideGeometry, toInside: insideGeometry)])
                    }
                    
                    contentWithInfo?(_scrollViewInfo.wrappedValue)
                    content?()
                }
            }
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self, perform: { value in
                DispatchQueue.main.async {
                    
                    let info = value[0]
                    scrollViewInfo = info
                    
                    if let loadMoreOffset = loadMoreOffset, info.offset + info.size.height > info.contentSize.height + loadMoreOffset {
                        loadMore?()
                    }
                }
            })
        }
    }
    
    private func calculateOffset(fromOutside outsideGeometry: GeometryProxy, toInside insideGeometry: GeometryProxy) -> ScrollViewInfo {
        
        let outerFrame = outsideGeometry.frame(in: .global)
        let innerFrame = insideGeometry.frame(in: .global)
        
        let info = ScrollViewInfo(offset: outerFrame.minY - innerFrame.minY, size: outerFrame.size, contentSize: innerFrame.size)
        
        return info
    }
}
