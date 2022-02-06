//
//  UILabel.swift
//  MackDuck
//
//  Created by sumin on 2022/02/06.
//

import UIKit

extension UILabel {
    // 행간 조절 : https://ideveloper.tistory.com/entry/Swift-UILabel%EC%97%90-LineSpace-%EC%A3%BC%EA%B8%B0
    func setLinespace(spacing: CGFloat) {
        if let text = self.text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = spacing
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                         value: style,
                                         range: NSMakeRange(0, attributeString.length))
            
            self.attributedText = attributeString
        }
    }
}
