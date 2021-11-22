//
//  HomeViewController.swift
//  MackDuck
//
//  Created by sumin on 2021/11/16.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var recommendButton: UIButton!
    @IBOutlet weak var tabBar: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .mainBlack
        
        mainTitle.text = "맥주 이름이\n무엇인가요?"
        mainTitle.textColor = .mainWhite
        
       
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        recommendButton.subtitleLabel?.textColor = .mainGray // 추천버튼 subtitle 색상 변경
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    

}

