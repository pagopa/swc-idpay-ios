//
//  SheetView.swift
//
//  Created by Stefania Castiglioni on 17/01/24.
//

import SwiftUI

public struct SheetView<Content: View>: View {
    
    @Binding var showSheetPage: Bool
    var maxHeight: CGFloat?
    @State private var showSheet: Bool = false
    @State private var offset: CGSize = .zero
    
    private var content: () -> Content
    
    public init(showSheetPage: Binding<Bool>, maxHeight: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        _showSheetPage = showSheetPage
        self.content = content
        self.maxHeight = maxHeight
    }
    
    public var body: some View {
        if showSheetPage {
            GeometryReader { proxy in
                ZStack {
                    Color
                        .black
                        .opacity(0.25)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showSheet = false
                        }
                    
                    VStack {
                        Spacer()
                        
                        Sheet(
                            maxHeight: maxHeight ?? proxy.size.height/2.0,
                            show: $showSheet,
                            content: content
                        )
                        .offset(y: showSheet ? offset.height : (maxHeight ?? proxy.size.height/2.0))
                        .animation(.easeInOut(duration: 0.4), value: showSheet)
                    }
                    .ignoresSafeArea()
                }
            }
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
                        showSheet = true
                }
            }
            .onDisappear(perform: {
                hideSheet()
            })
            .onChange(of: showSheet) { newValue in
                if newValue == false {
                    hideSheet()
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        guard gesture.translation.height > 0 else { return }
                        offset = gesture.translation
                    }
                    .onEnded { _ in
                        if abs(offset.height) > 60 {
                            hideSheet()
                        } else {
                            offset = .zero
                        }
                    }
            )

        }

    }
    
    private func hideSheet() {
        // remove the card
        showSheet = false
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            if showSheetPage {
                showSheetPage = false
            }
            offset = .zero
        }
    }
}

private struct Sheet<Content: View>: View {
    
    var maxHeight: CGFloat
    @Binding var show: Bool
    var content: Content

    init(maxHeight: CGFloat, show: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) {
        self.maxHeight = maxHeight
        _show = show
        self.content = content()
    }

    var body: some View {
        VStack {
            
            HStack(alignment: .top) {
                Spacer()
                
                Button {
                    show.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 4.0)
                        .frame(width: 40, height: 4)
                        .foregroundColor(.grey200)
                }
                
                Spacer()
            }
            .padding(.top, Constants.xsmallSpacing)
            .padding(.bottom, Constants.mediumSpacing)

            content
        }
        .frame(maxWidth: .infinity, maxHeight: maxHeight)
        .background(Color.white)
        .clipShape (
            .rect(
                topLeadingRadius: 40,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 40
            )
        )
    }
}

struct SheetModifier<V>: ViewModifier where V: View {
    
    @Binding var show: Bool
    var maxHeight: CGFloat?
    var sheetContent: () -> V
    
    func body(content: Content) -> some View {
        
        content
            .overlay {
                SheetView(showSheetPage: $show, maxHeight: maxHeight, content: sheetContent)
            }
    }
}

extension View {
    public func showSheet<Content>(isVisibile: Binding<Bool>, maxHeight: CGFloat? = nil, content: @escaping () -> Content) -> some View where Content:View {
        modifier(SheetModifier(show: isVisibile, maxHeight: maxHeight, sheetContent: content))
    }
}

struct SheetDemoView: View {
    
    @State var showSheet: Bool = false
    
    var body: some View {
        ZStack {
            Color.yellow
            
            VStack {
                Text("Sheet it!")
                Button {
                    showSheet.toggle()
                } label: {
                    Text("Show")
                }
            }
        }
        .showSheet(isVisibile: $showSheet, maxHeight: 300.0) {
            List {
                Text("Item 1")
                Text("Item 2")
            }
            .listStyle(.plain)
            .scrollDisabled(true)
            .padding(40)
        }
    }
}

#Preview {
    SheetDemoView()
}
