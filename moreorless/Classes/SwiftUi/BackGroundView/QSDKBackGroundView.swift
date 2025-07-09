//
//  BackGroundView.swift
//  QuizeApp
//
//  Created by Vishal Vijayvargiya on 21/08/23.
//

import SwiftUI

struct QSDKBackGroundView: View {
    var body: some View {
        ZStack {
            MOLTheme.getColor(named: .QSDKBackGround_000040)
                .ignoresSafeArea()
            Image(uiImage:MOLTheme.getImage(named:MolImageName.QSDKtrofiBanner.name) ?? UIImage())
                 .resizable()
                 .scaledToFit()
                 .edgesIgnoringSafeArea(.all)
                 .padding(.top,-268)
        }
    }
}

struct BackGroundView_Previews: PreviewProvider {
    static var previews: some View {
        QSDKBackGroundView()
    }
}
