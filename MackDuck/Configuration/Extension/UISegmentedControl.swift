//
//  UISegmentedControl.swift
//  MackDuck
//
//  Created by sumin on 2022/01/12.
//

import Foundation
import UIKit

// https://stackoverflow.com/questions/42755590/how-to-display-only-bottom-border-for-selected-item-in-uisegmentedcontrol

extension UISegmentedControl{
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.mainBlack.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

        // segmentedControl의 가운데 분리 설정 부분.
        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.mainBlack.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        // segmentedControl의 text와 폰트 설정 부분.
        let fontRegular = UIFont(name: "NotoSansKR-Regular", size: 16)
        let fontBold = UIFont(name: "NotoSansKR-Bold", size: 16)
        self.setTitleTextAttributes([NSAttributedString.Key.font: fontRegular!, NSAttributedString.Key.foregroundColor: UIColor.mainGray], for: .normal) // segmentedControl 미선택 - 회색
        self.setTitleTextAttributes([NSAttributedString.Key.font: fontBold!, NSAttributedString.Key.foregroundColor: UIColor(red: 249/255, green: 249/255, blue: 253/255, alpha: 1.0)], for: .selected) // segmentedControl 선택 - 흰색
        
    }

    func addUnderlineForSelectedSegment(){
        removeBorder()
//        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineWidth: CGFloat = UIScreen.main.bounds.width / CGFloat(self.numberOfSegments) // 밑줄 분할이 정확하게 안나뉘는 것 해결 방법.
        let underlineHeight: CGFloat = 3.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 3.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 253/255, alpha: 1.0) // White
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}

extension UIImage{

    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
    }
}
