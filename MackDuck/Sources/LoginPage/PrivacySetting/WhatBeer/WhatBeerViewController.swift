//
//  WhatBeerViewController.swift
//  MackDuck
//
//  Created by sumin on 2022/02/07.
//

import UIKit

class WhatBeerViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar! // 상단 네비게이션 바
    @IBOutlet weak var scrollViewBackground: UIView! // scrollView의 View
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel! // #라거 #필스너 #스타우트 #에일 등 맥주 종류에 대해 알아보자!
    
    @IBOutlet weak var lagersSubTitle: UILabel! // 효모가 액체 밑으로 ~~
    @IBOutlet weak var lagerExplain: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .subBlack

        navigationBar.barTintColor = .subBlack
        navigationBar?.isTranslucent = false // 네비게이션바 반투명 제거
        
        scrollViewBackground.backgroundColor = .subBlack
        self.navigationController?.navigationBar.backgroundColor = .subBlack // 이걸 해줘야 네비게이션바 색 바뀌는듯.
        self.navigationController?.navigationBar.barTintColor = .subBlack // 상단 네비게이션 바 색상 변경
        self.navigationController?.navigationBar.isTranslucent = false // 상단 네비게이션 바 반투명 제거

        mainTitle.text = "흠..! 이게\n무슨 맥주지?"
        subTitle.text = "#라거 #필스너 #스타우트 #에일 등\n맥주 종류에 대해 알아보자!"
        mainTitle.setLinespace(spacing: 15)
        subTitle.setLinespace(spacing: 10)
        lagersSubTitle.text = "효모가 액체 밑으로 가라앉는 상태를 하면 발효 되는 라거로\n장기간 저온에서 만들어져 담백하고 깔끔한 맛을 가진 현대의 대중\n맥주라고 할 수 있어요!"
        lagerExplain.text = "대중 맥주를 대표하고 대다수 국가에서 가장 많은 사랑을 받고 있는\n라거! 라거의 큰 특징은 연한 황금빛, 라이트함, 적당한 쌉쌀함,\n청량감을 갖는 맥주로 입안에서 맛이 빠르게 사라지는 라이트 바디가 특징인 맥주랍니다!"
        
    }
    
    // 좌측 상단 뒤로가기 버튼 클릭 시 -> 개인정보 설정 창으로 이동.
    @IBAction func didTabBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
