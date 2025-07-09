//
//  QuizPollSDKConnection.swift
//  Pods
//
//  Created by Vishal Vijayvargiya on 23/08/23.
//

import UIKit
import SwiftUI

public class QuizSDKConnection {
    public init() {}
    
    public func openViewController(from viewController: UIViewController) {
        let QuizApp =  MolSplashView()
        viewController.host(component: AnyView(QuizApp), into: viewController.view)
        
    }
}
