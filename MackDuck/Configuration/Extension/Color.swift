//
//  Color.swift
//  MackDuck
//
//  Created by sumin on 2021/11/15.
//

//import Foundation
import UIKit

extension UIColor {
    // MARK: hex code를 이용하여 정의
    // ex. UIColor(hex: 0xF5663F)
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    // MARK: 메인 테마 색 또는 자주 쓰는 색을 정의
    // ex. label.textColor = .mainOrange
    class var mainBlack: UIColor { UIColor(hex: 0x121212) }
    class var mainWhite: UIColor { UIColor(hex: 0xF9F9FD) }
    class var mainGray: UIColor { UIColor(hex: 0x888888) }
//    class var denyPink: UIColor { UIColor(hex: 0xFEE3F3) }
}
