//
//  UIViewContoler+Extention.swift
//  QuizeApp
//
//  Created by Vishal Vijayvargiya on 21/08/23.
//

import UIKit
import SwiftUI

extension UIViewController {
    /// component: View created by SwiftUI
    /// targetView: The UIView that will host the component
    func host(component: AnyView, into targetView: UIView) {
        let controller = UIHostingController(rootView: component)
        self.addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        targetView.addSubview(controller.view)
        controller.didMove(toParent: self)

        NSLayoutConstraint.activate([
            controller.view.widthAnchor.constraint(equalTo: targetView.widthAnchor, multiplier: 1),
            controller.view.heightAnchor.constraint(equalTo: targetView.heightAnchor, multiplier: 1),
            controller.view.centerXAnchor.constraint(equalTo: targetView.centerXAnchor),
            controller.view.centerYAnchor.constraint(equalTo: targetView.centerYAnchor)
        ])
    }
}

extension UIScreen{
  static let screenWidth = UIScreen.main.bounds.size.width
  static let screenHeight = UIScreen.main.bounds.size.height
  static let screenSize = UIScreen.main.bounds.size
}

extension UIView{
    
    //MARK:- Load NIb Methods
    
    /// Resposible to create and manage UIView from `Nib` file from any class.
    /// Use
    /// let view : LoaderView = .fromNib()
    ///
    /// - returns:Same Nib Class
    class func fromNib<T: UIView>(nibName: String?=nil, index:Int = 0) -> T{
        return PodBundle.bundle.loadNibNamed(nibName ?? String(describing: T.self), owner: nil, options: nil)![index] as! T
    }
    
    /// Resposible to create and manage UIView from `Nib` file from `File's Owner`..
    ///
    /// - returns: UIView
    func loadViewFromNib() -> UIView! {
        //let bundle = Bundle.init(for: self.classForCoder)
        let bundle = PodBundle.bundle
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    /// Embed Leading, Trailing, Top and Bottom constraints with 0
    ///
    /// - parameter view:                      UIView to be embeded
    /// - parameter bottomConstraintPriority:  bottom constraints priority, `999` is Default.
    func addEmbededSubview(_ view: UIView, atIndex: Int?=nil, topConstant: CGFloat = 0, bottomConstant: CGFloat = 0, leftConstant: CGFloat = 0, rightConstant: CGFloat = 0){
        
        view.translatesAutoresizingMaskIntoConstraints = false
        if let atIndex = atIndex{
            self.insertSubview(view, at: atIndex)
        }else{
            self.addSubview(view)
        }
        let topConstraints = NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: topConstant)
        let bottomConstraints = NSLayoutConstraint.init(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: bottomConstant)
        let leftConstraints = NSLayoutConstraint.init(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: leftConstant)
        let rightConstraints = NSLayoutConstraint.init(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: rightConstant)
        
        self.addConstraints([topConstraints,bottomConstraints,leftConstraints,rightConstraints])
    }
    
    func addSubviewInCenter(_ view: UIView, constantX: CGFloat = 0, constantY:CGFloat = 0, width: CGFloat? = nil, height: CGFloat? = nil){
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(view)
        
//        if let width = width {
//            let widthConstraint = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: width)
//            self.addConstraint(widthConstraint)
//        }
//        if let height = height {
//            let heightConstraint = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: height)
//            self.addConstraint(heightConstraint)
//        }
        
        let centerX = NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: constantX)
        let centerY = NSLayoutConstraint.init(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: constantY)
    
        self.addConstraints([centerX,centerY])
    }
    
    /// Embed Leading, Trailing, Top and Bottom constraints with 0
    ///
    /// - parameter view:                      UIView to be embeded
    /// - parameter bottomConstraintPriority:  bottom constraints priority, `999` is Default.
    func embed(view:UIView, atIndex:Int?=nil) {
        
        view.translatesAutoresizingMaskIntoConstraints = false;
        if let atIndex = atIndex {
            self.insertSubview(view, at: atIndex)
        }else{
            self.addSubview(view)
        }
        let topConstraint = NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint.init(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        //bottomConstraint.priority = UILayoutPriority(rawValue: Float(bottomConstraintPriority))
        let leftConstraint = NSLayoutConstraint.init(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint.init(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        
        self.addConstraints([topConstraint,leftConstraint,bottomConstraint,rightConstraint])
    }
}

extension UIView {
    func addConstrained(subview: UIView) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

extension View {
    @ViewBuilder func conditionalBackground<TrueContent: View, FalseContent: View>(_ condition: Bool, trueContent: @escaping (Self) -> TrueContent, falseContent: @escaping (Self) -> FalseContent) -> some View {
        if condition {
            trueContent(self)
        } else {
            falseContent(self)
        }
    }
}
