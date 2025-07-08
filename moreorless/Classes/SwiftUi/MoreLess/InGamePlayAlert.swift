//
//  InGamePlayAlert.swift
//  quiz
//
//  Created by Milind Trivedi on 29/12/23.
//

import SwiftUI

struct InGamePlayAlert: View {
    
    @Binding var isPresented: Bool
    @Binding var txt : String
    
    var body: some View {
        VStack(spacing: 12) {
            
            Text(txt)
                .foregroundColor(.black)
                .font(.system(size: 20))
                .bold()
                .padding()
            
        } .preferredColorScheme(.light)
        .padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
        .background(Color.white.opacity(0.75).cornerRadius(20))
    }
}
//
//#Preview {
//    InGamePlayAlert()
//}
