//
//  QPSDKButtonStyle.swift
//  QuizeApp
//
//  Created by Vishal Vijayvargiya on 22/08/23.
//

import SwiftUI


enum ButtonStyle {
    case primary
    case secondary(borderWidth: CGFloat = 2)
    case custom(borderColor: Color, borderWidth: CGFloat)
}

struct QSDKCustomButtonStyle<Content: View>: View {
    let buttonStyle: ButtonStyle
    let content: Content
    
    init(buttonStyle: ButtonStyle, @ViewBuilder content: () -> Content) {
        self.buttonStyle = buttonStyle
        self.content = content()
    }
    
    var body: some View {
        switch buttonStyle {
        case .primary:
            return AnyView(content
                .padding()
                .background(MOLTheme.getColor(named: .QPSDKPrimary))
                .foregroundColor(MOLTheme.getColor(named: .QSDKButtonTitle00004B))
                .cornerRadius(14)
            )
        case .secondary(let borderWidth):
            return AnyView(content
                .padding()
                .foregroundColor(MOLTheme.getColor(named: .QPSDKWhite))
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(MOLTheme.getColor(named: .QPSDKPrimary), lineWidth: borderWidth)
                )
            )
        case .custom(let borderColor, let borderWidth):
            return AnyView(content
                .padding()
                .background(Color.clear)
                .foregroundColor(.black)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
            )
        }
    }
}

extension View {
    func buttonStyle(_ style: ButtonStyle) -> some View {
        QSDKCustomButtonStyle(buttonStyle: style) {
            self
        }
    }
}
