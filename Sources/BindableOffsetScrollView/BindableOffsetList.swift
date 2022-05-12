//
//  File.swift
//  
//
//  Created by Franklyn Weber on 16/03/2021.
//

import SwiftUI


/*
 Not entirely sure this is doable as List hides its internal geometry :(
 */

public struct BindableOffsetList<SelectionValue, Content> : View where SelectionValue : Hashable, Content : View {
    
    @Binding var contentInfo: ScrollViewInfo
    
    
    private let list: List<SelectionValue, Content>
    
    
    public init(selection: Binding<Set<SelectionValue>>?, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder content: () -> Content) {
        list = List(selection: selection, content: content)
        _contentInfo = contentInfo
    }
    
    public init(selection: Binding<SelectionValue?>?, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder content: () -> Content) {
        list = List(selection: selection, content: content)
        _contentInfo = contentInfo
    }
    
    public init<Data, RowContent>(_ data: Data, selection: Binding<Set<SelectionValue>>?, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Data.Element) -> HStack<RowContent>) where Content == ForEach<Data, Data.Element.ID, HStack<RowContent>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        list = List(data, selection: selection, rowContent: rowContent)
        _contentInfo = contentInfo
    }
    
    public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        list = List(data, children: children, selection: selection, rowContent: rowContent)
        _contentInfo = contentInfo
    }
    
    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<Set<SelectionValue>>?, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Data.Element) -> HStack<RowContent>) where Content == ForEach<Data, ID, HStack<RowContent>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        list = List(data, id: id, selection: selection, rowContent: rowContent)
        _contentInfo = contentInfo
    }
    
    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<Set<SelectionValue>>?, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        list = List(data, id: id, children: children, selection: selection, rowContent: rowContent)
        _contentInfo = contentInfo
    }
    
    public init<RowContent>(_ data: Range<Int>, selection: Binding<Set<SelectionValue>>?, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Int) -> RowContent) where Content == ForEach<Range<Int>, Int, HStack<RowContent>>, RowContent : View {
        list = List(data, selection: selection, rowContent: rowContent)
        _contentInfo = contentInfo
    }
    
    public init<Data, RowContent>(_ data: Data, selection: Binding<SelectionValue?>?, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Data.Element) -> HStack<RowContent>) where Content == ForEach<Data, Data.Element.ID, HStack<RowContent>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        list = List(data, selection: selection, rowContent: rowContent)
        _contentInfo = contentInfo
    }
    
    public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        list = List(data, children: children, selection: selection, rowContent: rowContent)
        _contentInfo = contentInfo
    }
    
    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, selection: Binding<SelectionValue?>?, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Data.Element) -> HStack<RowContent>) where Content == ForEach<Data, ID, HStack<RowContent>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        list = List(data, id: id, selection: selection, rowContent: rowContent)
        _contentInfo = contentInfo
    }
    
    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, selection: Binding<SelectionValue?>?, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        list = List(data, id: id, children: children, selection: selection, rowContent: rowContent)
        _contentInfo = contentInfo
    }
    
    public init<RowContent>(_ data: Range<Int>, selection: Binding<SelectionValue?>?, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Int) -> HStack<RowContent>) where Content == ForEach<Range<Int>, Int, HStack<RowContent>>, RowContent : View {
        list = List(data, selection: selection, rowContent: rowContent)
        _contentInfo = contentInfo
    }
    
    
    public var body: some View {
        Text("Placeholder")
//        GeometryReader { outsideGeometry in
//
//            list
//                .preference(key: ScrollViewOffsetPreferenceKey.self, value: calculateOffset(fromOutside: outsideGeometry, toInside: outsideGeometry))
//            ScrollView(axes, showsIndicators: showIndicators) {
//
//                ZStack(alignment: axes == .vertical ? .top : .leading) {
//
//                    GeometryReader { insideGeometry in
//                        Color.clear
//                        calculateOffset(fromOutside: outsideGeometry, toInside: insideGeometry)
//                    }
//
//                    if let wrappedValue = tracker.contentInfo?.wrappedValue {
//                        content(wrappedValue)
//                    }
//                }
//            }
//        }
//        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self, perform: {
//            contentInfo = $0
//        })
    }
    
    private func calculateOffset(fromOutside outsideGeometry: GeometryProxy, toInside insideGeometry: GeometryProxy) -> ScrollViewInfo {
        
        let outerFrame = outsideGeometry.frame(in: .global)
        let innerFrame = insideGeometry.frame(in: .global)
        
        let info = ScrollViewInfo(offset: outerFrame.minY - innerFrame.minY, size: outerFrame.size, contentSize: innerFrame.size)
        
        return info
    }
}


extension BindableOffsetList where SelectionValue == Never {
    
    public init(contentInfo: Binding<ScrollViewInfo>, @ViewBuilder content: () -> Content) {
        list = List(content: content)
        _contentInfo = contentInfo
    }
    
    public init<Data, RowContent>(_ data: Data, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Data.Element) -> HStack<RowContent>) where Content == ForEach<Data, Data.Element.ID, HStack<RowContent>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        list = List(data, rowContent: rowContent)
        _contentInfo = contentInfo
    }
    
    public init<Data, RowContent>(_ data: Data, children: KeyPath<Data.Element, Data?>, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, Data.Element.ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, RowContent : View, Data.Element : Identifiable {
        list = List(data, children: children, rowContent: rowContent)
        _contentInfo = contentInfo
    }
    
    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Data.Element) -> HStack<RowContent>) where Content == ForEach<Data, ID, HStack<RowContent>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        list = List(data, id: id, rowContent: rowContent)
        _contentInfo = contentInfo
    }
    
    public init<Data, ID, RowContent>(_ data: Data, id: KeyPath<Data.Element, ID>, children: KeyPath<Data.Element, Data?>, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent) where Content == OutlineGroup<Data, ID, RowContent, RowContent, DisclosureGroup<RowContent, OutlineSubgroupChildren>>, Data : RandomAccessCollection, ID : Hashable, RowContent : View {
        list = List(data, id: id, children: children, rowContent: rowContent)
        _contentInfo = contentInfo
    }
    
    public init<RowContent>(_ data: Range<Int>, contentInfo: Binding<ScrollViewInfo>, @ViewBuilder rowContent: @escaping (Int) -> HStack<RowContent>) where Content == ForEach<Range<Int>, Int, HStack<RowContent>>, RowContent : View {
        list = List(data, rowContent: rowContent)
        _contentInfo = contentInfo
    }
}


