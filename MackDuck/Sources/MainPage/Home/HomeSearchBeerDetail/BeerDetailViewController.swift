//
//  BeerDetailViewController.swift
//  MackDuck
//
//  Created by sumin on 2022/01/05.
//

import UIKit

class BeerDetailViewController: UIViewController {

    var introBeerDetailDataManager: IntroBeerDetailDataManager = IntroBeerDetailDataManager() // 맥주 디테일 정보 가져오는 dataManager
    var beerId: Int = 0
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var scrollViewBackground: UIView! // scrollView의 View

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.tabBarController?.tabBar.isHidden = true // 하단 탭바 가리기
        
        self.view.backgroundColor = .mainYellow
        self.navBar.backgroundColor = .mainBlack
        self.navBar.barTintColor = .mainBlack
        self.navBar.isTranslucent = false // 상단 네비게이션 바 반투명 제거
        scrollViewBackground.backgroundColor = .mainBlack
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.introBeerDetailDataManager.getBeerDetailInfo(beerId: beerId, delegate: self) // 맥주정보 가져오는 api 호출.
        
    }
    
    @IBAction func clickHomeButton(_ sender: UIBarButtonItem) { // 홈 버튼 클릭 시,
        let goHome = UIStoryboard(name: "MainPageStoryboard", bundle: nil)
        let goHomeVC = goHome.instantiateViewController(withIdentifier: "MainPageTabBarController")
        goHomeVC.modalPresentationStyle = .fullScreen
        self.present(goHomeVC, animated: true, completion: nil)
    }
    
    @IBAction func clickSearchButton(_ sender: UIBarButtonItem) { // 검색 버튼 클릭 시,
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - intro 맥주정보 GET Api
extension BeerDetailViewController {
    
    // userId가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에서 최근검색어 삭제하게 설정.
    func didSuccessGetBeerInfo(_ result: IntroBeerDetailResponse) {
        print("서버로부터 맥주정보 GET 성공!")
        print("response 내용 : \(result)")
        
        
    }

    func failedToGetBeerInfo(message: String, code: Int) { // 오류메시지 & code번호 몇인지
        print("서버 Request 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
        }
        else if code == 3011 { // 실패 이유 : "상품에 관한 상세화면이 없어요."
            
        }
    }
    
}
