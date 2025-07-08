//
//  QSDKImageView.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 02/11/23.
//

import SwiftUI
import Combine

//class ImageLoader: ObservableObject {
//    @Published var image: UIImage?
//    private var cancellable: AnyCancellable?
//    
//    func loadImage(from urlString: String) {
//            guard let url = URL(string: urlString) else {
//                return
//            }
//
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data, let loadedImage = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self.image = loadedImage
//                    }
//                }
//            }.resume()
//        }
//
//}
//
//struct ImageView: View {
//    @ObservedObject private var imageLoader = ImageLoader()
//    private let imageUrl: String
//    private let placeholder: Image?
//    
//    init(imageUrl: String, placeholder: Image? = nil) {
//        self.imageUrl = imageUrl
//        self.placeholder = placeholder
//        imageLoader.loadImage(from: imageUrl)
//    }
//    
//    var body: some View {
//        if let image = imageLoader.image {
//            return Image(uiImage: image)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .eraseToAnyView()
//        } else if let placeholder = placeholder {
//            return placeholder
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .eraseToAnyView()
//        } else {
//            return ProgressView()
//                .eraseToAnyView()
//        }
//    }
//}
//
//extension View {
//    func eraseToAnyView() -> AnyView {
//        return AnyView(self)
//    }
//}
