//
//  PullToRefreshModifier.swift
//  Pods
//
//  Created by Vishal on 25/01/25.
//


import SwiftUI

struct PullToRefreshModifier: ViewModifier {
    @Binding var isRefreshing: Bool
    let onRefresh: () -> Void
    private let threshold: CGFloat = 200 // Adjust the pull threshold here

    func body(content: Content) -> some View {
        ScrollView {
            VStack(spacing:0){
                GeometryReader { geometry in
                    Color.clear
                        .onChange(of: geometry.frame(in: .global).minY) { value in
                            if value > threshold && !isRefreshing {
                                print("Refreshing..")
                                refreshTriggered()
                            }
                        }
                }.frame(height: 0)
            
                
                content
                
                
            }
        }
    }

    private func refreshTriggered() {
        isRefreshing = true
        onRefresh()
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { // Simulate network delay
            isRefreshing = false
        }
    }
}

extension View {
    func pullToRefresh(isRefreshing: Binding<Bool>, onRefresh: @escaping () -> Void) -> some View {
        self.modifier(PullToRefreshModifier(isRefreshing: isRefreshing, onRefresh: onRefresh))
    }
}
