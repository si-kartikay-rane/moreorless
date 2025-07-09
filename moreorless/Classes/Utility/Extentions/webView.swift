//
//  webView.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 20/02/24.
//

import SwiftUI
import WebKit

struct CommonWebView: View {
    
    var url: String?
    var titleString: String?
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        WebView(url: url)
            .navigationBarTitle(titleString ?? "")
            .navigationBarBackButtonHidden()
            .navigationBarItems(leading:
            Button(action: {
                if  NetworkWrapper.isInternerConnected(){
                    self.presentationMode.wrappedValue.dismiss()
                }
            }) {
                Image(uiImage:MOLTheme.getImage(named:MolImageName.QSDK_NavBack.name) ?? UIImage())
                    .imageScale(.large)
            })
            .onAppear{
                MOLTheme.currentnavigation?.style(style: .withBgImage(image: MOLTheme.getImage(named: MolImageName.QSDKNavigationBG.name) ?? UIImage(),color:UIColor(MOLTheme.getColor(named: .QSDK_NavImage051139))))
            }
    }
}


struct WebView: UIViewRepresentable {
    
    typealias UIViewType = WKWebView
    
    let url: String?
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.backgroundColor = .clear
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let urlString = url, let webviewUrl = URL(string: urlString) else { return }
        uiView.load(URLRequest(url: webviewUrl))
    }
}
