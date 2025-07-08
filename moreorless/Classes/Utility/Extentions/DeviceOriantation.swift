//
//  DeviceOriantation.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 13/10/23.
//

import Foundation
import SwiftUI
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// A View wrapper to make the modifier easier to use
extension View {
    func quizOnRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}


class SizeViewModel: ObservableObject {
    @Published var SizeChange: Bool = false
    @Published var orientation = UIDeviceOrientation.unknown
    
    func fetchData() {
        // Fetch data from an API or perform some asynchronous task
        // Update self.data property
        self.SizeChange =  (orientation.isPortrait && (UIScreen.screenWidth > 1024))
        self.orientation =  UIDevice.current.orientation
       
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.hidesWhenStopped = true
        indicator.color =  .white
        return indicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
