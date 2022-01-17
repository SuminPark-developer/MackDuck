//
//  SeeReviewMoreImageViewController.swift
//  MackDuck
//
//  Created by sumin on 2022/01/17.
//

import UIKit

class SeeReviewMoreImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .mainBlack
        self.navigationController?.navigationBar.backgroundColor = .mainBlack // 이걸 해줘야 네비게이션바 색 바뀌는듯.
        self.navigationController?.navigationBar.barTintColor = .mainBlack // 상단 네비게이션 바 색상 변경
        self.navigationController?.navigationBar.isTranslucent = false // 상단 네비게이션 바 반투명 제거
        
        
    }
    
    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

    
    

}
