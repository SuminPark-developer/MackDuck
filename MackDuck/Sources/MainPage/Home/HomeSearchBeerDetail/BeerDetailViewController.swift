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
    // 맥주 정보
    @IBOutlet weak var beerImage: UIImageView! // 맥주 이미지뷰
    @IBOutlet weak var beerNameEng: UILabel! // 맥주 (영어) 이름 - JEJU Wit ale
    @IBOutlet weak var beerNameKor: UILabel! // 맥주 (한글) 이름 - 제주 위트 에일
    @IBOutlet weak var shareButton: UIButton! // 공유 버튼
    @IBOutlet weak var bookMarkButton: UIButton! // 북마크(즐겨찾기) 버튼
    @IBOutlet var starImages: [UIImageView]! // 별 이미지 모음
    @IBOutlet weak var starScore: UILabel! // 별점(소수점)
    @IBOutlet weak var reviewCount: UILabel! // 리뷰 개수
    @IBOutlet weak var labelCountry: UILabel! // 원산지 : 벨기에산
    @IBOutlet weak var labelManufacturer: UILabel! // 제조사 : 제주 맥주
    @IBOutlet weak var labelBeerKind: UILabel! // 맥주 종류 : 에일
    @IBOutlet weak var labelAlcohol: UILabel! // 알콜 도수 : 5.3%
    @IBOutlet weak var labelIngredient: UILabel! // 재료 : 보리, 맥아, 홉, 감귤피, 오렌지 껍질
    @IBOutlet weak var labelFeature: UILabel! // 특징 : 오렌지 껍질과 ~~
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .mainBlack
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
        
        // 맥주 정보 ui 작업
        let url = URL(string: result.result.beerImgUrl)
        // DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
        DispatchQueue.global(qos: .background).async { // DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.beerImage.image = UIImage(data: data!) // 만약 url이 없다면(안 들어온다면) try-catch로 확인해줘야 함.
                self.beerImage.contentMode = .scaleAspectFit
            }
        }
        beerNameEng.text = result.result.nameEn // 맥주 (영어) 이름 설정.
        beerNameKor.text = result.result.nameKr // 맥주 (한글) 이름 설정.
        starScore.text = result.result.reviewAverage // 별점
        reviewCount.text = String(result.result.reviewCount) + "개의 리뷰" // ex) 0개의 리뷰
        
        // 소수점 score를 정수로 바꾸고 그 점수까지 스타 yellow이미지로 바꾸게 함.
        let score: Int = Int(floor(Double(result.result.reviewAverage)!))
        
        for i in 0..<score {
            starImages[i].image = UIImage(named: "searchResultStarYellow.png")
        }
        
        labelCountry.text = "원산지 : \(result.result.country)"
        labelManufacturer.text = "제조사 : \(result.result.manufacturer)"
        labelBeerKind.text = "맥주 종류 : \(result.result.beerKind)"
        labelAlcohol.text = "알콜 도수 : \(result.result.alcohol)"
        labelIngredient.text = "재료 : \(result.result.ingredient)"
        labelFeature.text = "특징 : \(result.result.feature)"
        
        
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
