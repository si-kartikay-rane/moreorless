//
//  SocialSharing.swift
//  quiz
//
//  Created by Vishal Vijayvargiya on 06/12/23.
//

import Foundation
import SwiftUI



struct ActivityViewPresenter: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let items: [Any]
    var completionHandler: ((Bool, [Any]?, Error?) -> Void)?
    
    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                let filteredActivityItems: [Any] = {
                    let result: [Any] = items.enumerated().compactMap { index, item in
                        if let activity = item as? String, activity == QUIZTheme.QuizScreenShotKey {
                            // If the activity matches, remove it and add a screenshot
                            if let img = TakeScreenShotforQuiz() {
                                return img
                            }
                            return nil  // Exclude the matched activity from the new array
                        }
                        return item
                    }
                    return result
                }()
                
                
                DispatchQueue.main.async {
                    
                    let activityViewController = UIActivityViewController(activityItems: filteredActivityItems, applicationActivities: nil)
                    uiViewController.present(activityViewController, animated: true) {
                        isPresented = false
                    }
                    
                    activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, activityError in
                        self.completionHandler?(completed, returnedItems, activityError)
                    }
                }
            }
        }
    }
    
    private func TakeScreenShotforQuiz() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: UIScreen.main.bounds)

        return renderer.image { context in
            UIApplication.shared.windows.first?.layer.render(in: context.cgContext)
        }
    }
}
