//
//  HomeViewController.swift
//  MackDuck
//
//  Created by sumin on 2021/11/16.
//

import UIKit

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mainTitle: UILabel! // 맥주 이름이 무엇인가요?
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var recommendButton: UIButton!
    @IBOutlet weak var dictionaryButton: UIButton!
    @IBOutlet weak var dictionaryButtonTitle: UILabel!
    @IBOutlet weak var dictionaryButtonSubTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel! // 맥주 정보
    
    @IBOutlet weak var tabBar: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .mainBlack
        
        mainTitle.text = "맥주 이름이\n무엇인가요?"
        mainTitle.textColor = .mainWhite
        subTitle.textColor = .mainWhite
       
        dictionaryButtonTitle.text = "이게\n무슨 맥주지?"
        dictionaryButtonSubTitle.text = "#알면 쓸모있는 맥주 상식\n#라거, 필스너, 스타우트 등"
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self // 네비게이션바 뒤로가기 제스쳐 - https://devsc.tistory.com/96
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        recommendButton.subtitleLabel?.textColor = .mainGray // 추천버튼 subtitle 색상 변경
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        recommendButton.subtitleLabel?.textColor = .mainGray // 추천버튼 subtitle 색상 변경
    }
    
    
    // 검색창 클릭 시,
    @IBAction func didTabSearchButton(_ sender: UIButton) {
        let homeSearchVC = (self.storyboard?.instantiateViewController(withIdentifier: "HomeSearchVC"))
        self.navigationController?.pushViewController(homeSearchVC!, animated: true)
    }
    
    
    // 추천 탭 클릭 시,
    @IBAction func didTabRecommendButton(_ sender: UIButton) {
        let homeRecommendVC = (self.storyboard?.instantiateViewController(withIdentifier: "HomeRecommendVC"))
        self.navigationController?.pushViewController(homeRecommendVC!, animated: true)
    }
    
    // 맥주 정보 클릭 시,
    @IBAction func didTabDictionaryButton(_ sender: UIButton) {
        let homeDictionaryVC = (self.storyboard?.instantiateViewController(withIdentifier: "HomeDictionaryVC"))
        self.navigationController?.pushViewController(homeDictionaryVC!, animated: true)
    }
    
}

