//
//  BindableOffsetScrollView.swift
//
//  Created by Franklyn Weber on 29/01/2021
//

import SwiftUI


public struct BindableOffsetScrollView<Content>: View where Content: View {
    
    private let axes: Axis.Set
    private let showIndicators: Bool
    private let content: (ScrollViewInfo) -> Content
    
    private let tracker: ScrollViewOffsetTracker
    
    @State private var scrollViewInfo = ScrollViewInfo(offset: 0, size: .zero)
    
    
    public init(forId id: String, axes: Axis.Set = .vertical, showIndicators: Bool = true, @ViewBuilder content: @escaping (ScrollViewInfo) -> Content) {
        
        self.axes = axes
        self.showIndicators = showIndicators
        self.content = content
        
        tracker = ScrollViewOffsetTracker.tracker(forId: id, contentInfo: nil)
        tracker.contentInfo = $scrollViewInfo
    }
    
    public init(forId id: String, axes: Axis.Set = .vertical, showIndicators: Bool = true, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder content: @escaping (ScrollViewInfo) -> Content) {
        
        self.axes = axes
        self.showIndicators = showIndicators
        self.content = content
        
        tracker = ScrollViewOffsetTracker.tracker(forId: id, contentInfo: contentInfo)
    }
    
    public var body: some View {
        
        GeometryReader { outsideGeometry in
            
            ScrollView(axes, showsIndicators: showIndicators) {
                
                ZStack(alignment: axes == .vertical ? .top : .leading) {
                    
                    GeometryReader { insideGeometry in
                        Color.clear
                        calculateOffset(fromOutside: outsideGeometry, toInside: insideGeometry)
                    }
                    
                    if let wrappedValue = tracker.contentInfo?.wrappedValue {
                        content(wrappedValue)
                    }
                }
            }
        }
    }
    
    private func calculateOffset(fromOutside outsideGeometry: GeometryProxy, toInside insideGeometry: GeometryProxy) -> EmptyView {
        
        let outerFrame = outsideGeometry.frame(in: .global)
        let innerFrame = insideGeometry.frame(in: .global)
        
        tracker.size = outerFrame.size
        
        if axes == .vertical {
            tracker.offset = outerFrame.minY - innerFrame.minY
        } else {
            tracker.offset = outerFrame.minX - innerFrame.minX
        }
        
        return EmptyView()
    }
}


public class ScrollViewOffsetTracker {
    
    private static var trackers: [String: ScrollViewOffsetTracker] = [:]
    
    var contentInfo: Binding<ScrollViewInfo>?
    var size: CGSize = .zero
    
    
    public static func tracker(forId id: String, contentInfo: Binding<ScrollViewInfo>?) -> ScrollViewOffsetTracker {
        
        if let tracker = trackers[id] {
            return tracker
        }
        
        let tracker = ScrollViewOffsetTracker(contentInfo)
        trackers[id] = tracker
        
        return tracker
    }
    
    public static func removeTracker(forId id: String) {
        trackers.removeValue(forKey: id)
    }
    
    private init(_ contentInfo: Binding<ScrollViewInfo>?) {
        self.contentInfo = contentInfo
    }
    
    var offset: CGFloat = 0 {
        didSet {
            guard offset != oldValue else {
                return
            }
            DispatchQueue.main.async {
                self.contentInfo?.wrappedValue = ScrollViewInfo(offset: self.offset, size: self.size)
            }
        }
    }
}


public struct ScrollViewInfo {
    public let offset: CGFloat
    public let size: CGSize
    
    public init(offset: CGFloat, size: CGSize) {
        self.offset = offset
        self.size = size
    }
}
