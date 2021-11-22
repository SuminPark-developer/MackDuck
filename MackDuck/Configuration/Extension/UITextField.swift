//
//  UITextField.swift
//  MackDuck
//
//  Created by sumin on 2021/11/16.
//


import UIKit


extension UITextField {
    // 참고 - t.ly/ghVt
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
    
    func addleftImage(image: UIImage) {
        let leftimage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        leftimage.image = image
        self.leftView = leftimage
        self.leftViewMode = .always
    }
    
    func addRightImage(image: UIImage) {
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        rightImage.image = image
        rightImage.contentMode = UIView.ContentMode.center
        self.rightView = rightImage
        self.rightViewMode = .always
    }
    
}
