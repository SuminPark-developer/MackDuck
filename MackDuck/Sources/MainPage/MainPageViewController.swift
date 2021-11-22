//
//  MainPageViewController.swift
//  MackDuck
//
//  Created by sumin on 2021/11/22.
//

import UIKit

class MainPageViewController: UITabBarController {

    @IBOutlet weak var mainPageTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // 탭바 height 변경 - https://stackoverflow.com/questions/58078821/change-tabbar-height-in-swift-5-for-ios-13
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 뷰 전체 높이 길이 - https://borabong.tistory.com/10?category=1035254
        mainPageTabBar.frame.size.height = (UIScreen.main.bounds.size.height) / 9.5
        mainPageTabBar.frame.origin.y = view.frame.height - (UIScreen.main.bounds.size.height) / 9.5
    }


}
