//
//  BeerDetailViewController.swift
//  MackDuck
//
//  Created by sumin on 2022/01/05.
//

import UIKit

class BeerDetailViewController: UIViewController {

    @IBOutlet weak var scrollViewBackground: UIView! // scrollView의 View
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.tabBarController?.tabBar.isHidden = true // 하단 탭바 가리기
        
        self.view.backgroundColor = .mainBlack
        scrollViewBackground.backgroundColor = .mainBlack
        self.navigationController?.navigationBar.backgroundColor = .mainBlack // 이걸 해줘야 네비게이션바 색 바뀌는듯.
        self.navigationController?.navigationBar.barTintColor = .mainBlack // 상단 네비게이션 바 색상 변경
        self.navigationController?.navigationBar.isTranslucent = false // 상단 네비게이션 바 반투명 제거
        
        
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = false // 하단 탭바 나타내기
//    }

    @IBAction func clickHomeButton(_ sender: UIBarButtonItem) { // 홈 버튼 클릭 시,
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func clickSearchButton(_ sender: UIBarButtonItem) { // 검색 버튼 클릭 시,
        self.navigationController?.popViewController(animated: true)
    }
    
}
