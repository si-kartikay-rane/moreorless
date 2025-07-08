//
//  UIWindowHelper.swift
//  quiz_Example
//
//  Created by Milind Trivedi on 18/03/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import Foundation

public extension UIWindow {
    /// returns current visible view controller
    func visibleViewController() -> UIViewController? {
        return getVisibleViewControllerFrom(rootViewController)
    }

    /// loops through ui structure, to return current visible controller
    private func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nav = vc as? UINavigationController {
            return getVisibleViewControllerFrom(nav.visibleViewController)
        }

        if let tab = vc as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController

            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return getVisibleViewControllerFrom(top)
            } else if let selected = tab.selectedViewController {
                return getVisibleViewControllerFrom(selected)
            }
        }
        if let presented = vc?.presentedViewController {
            return getVisibleViewControllerFrom(presented)
        }

        return vc
    }

    /// returns top presented view controller
    func topViewController() -> UIViewController? {
        if var topController = rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // topController should be topmost view controller
            return topController
        }
        return nil
    }

    /// returns safe area bottom inset (used for devices like iPhone X)
    static func safeAreaBottomInset() -> CGFloat {
        currentKeyWindow?.safeAreaInsets.bottom ?? 0
    }

    /// returns the key window
    static var currentKeyWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }

    /// Adds overlay view above all views constrainted by screen bounds with specific color.
    func addOverlayView(view: UIView, color: UIColor) {
        view.backgroundColor = color
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([view.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     view.topAnchor.constraint(equalTo: topAnchor),
                                     view.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     view.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
}

