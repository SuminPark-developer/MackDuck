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
    class var mainBlack: UIColor { UIColor(hex: 0x121212) } // (18, 18, 18)
    class var subBlack: UIColor { UIColor(hex: 0x0D0D0D) } // (13, 13, 13)
    class var subBlack2: UIColor { UIColor(hex: 0x222222) } // (34, 34, 34)
    class var subBlack3: UIColor { UIColor(hex: 0x1E1E1E) } // (30, 30, 30)
    class var mainWhite: UIColor { UIColor(hex: 0xF9F9FD) } // (249, 249, 253)
    class var mainGray: UIColor { UIColor(hex: 0x888888) } // (136, 136, 136)
    class var subGray1: UIColor { UIColor(hex: 0x444444) } // (68, 68, 68)
    class var subGray2: UIColor { UIColor(hex: 0x575757) } // (87, 87, 87)
    class var mainYellow: UIColor { UIColor(hex: 0xFCD602) } // (252, 214, 2)
    class var subYellow: UIColor { UIColor(hex: 0xFAD225) } // (250, 210, 37)
}
