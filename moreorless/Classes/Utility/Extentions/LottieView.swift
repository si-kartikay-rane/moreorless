////
////  LottieView.swift
////  Pods
////
////  Created by Vishal Vijayvargiya on 06/09/23.
////
//
//import SwiftUI
//import Lottie
//struct LottieView: UIViewRepresentable {
//    let urlString = (Constants.configData?.baseDomain ?? "") + (Constants.configData?.confettiUrl ?? "")
//  
//    func makeUIView(context: Context) -> UIView {
//        let container = UIView()
//        let animationView = LottieAnimationView()
//        if let URLP = URL(string: urlString), !urlString.isEmpty {
//            
//            URLSession.shared.dataTask(with: URLP) { data, _, error in
//                if let data = data {
//                    DispatchQueue.main.async {
//                        if let animation = try? JSONDecoder().decode(LottieAnimation.self, from: data) {
//                            animationView.animation = animation
//                            //animationView.contentMode = .scaleAspectFit
//                            animationView.animationSpeed = 1.0
//                            
//                            animationView.loopMode = .loop
//                            animationView.play()
//                        }
//                    }
//                } else if let error = error {
//                    
//                }
//            }.resume()
//        }
//        container.addSubview(animationView)
//        
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            animationView.topAnchor.constraint(equalTo: container.topAnchor),
//            animationView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
//            animationView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
//            animationView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
//        ])
//        
//        return container
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        // Update the view if needed
//    }
//}
