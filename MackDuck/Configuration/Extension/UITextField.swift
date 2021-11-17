//
//  UITextField.swift
//  MackDuck
//
//  Created by sumin on 2021/11/16.
//


import UIKit


extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
