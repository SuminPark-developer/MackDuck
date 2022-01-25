//
//  BeerDetailViewControllerExample.swift
//  MackDuck
//
//  Created by sumin on 2022/01/24.
//

import UIKit

class BeerDetailViewControllerExample: UIViewController {

    var introBeerDetailDataManager: IntroBeerDetailDataManager = IntroBeerDetailDataManager() // 맥주 디테일 정보 가져오는 dataManager
    var beerId: Int = 0
    var reviewCountSave: Int = 0 // 리뷰개수 0개면, 스크롤뷰 사이즈 줄일 용도로 쓰임.
    
//    @IBOutlet weak var scrollView: UIScrollView!
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
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tasteSmellView: UIView! // 맛/향 뷰
    @IBOutlet weak var reviewView: UIView! // 리뷰 235 뷰
    
    @IBOutlet weak var scrollViewBackgroundHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .mainBlack
//        self.navBar.backgroundColor = .mainBlack
//        self.navBar.barTintColor = .mainBlack
//        self.navBar.isTranslucent = false // 상단 네비게이션 바 반투명 제거
        self.navigationController?.navigationBar.backgroundColor = .mainBlack // 이걸 해줘야 네비게이션바 색 바뀌는듯.
        self.navigationController?.navigationBar.barTintColor = .mainBlack // 상단 네비게이션 바 색상 변경
        self.navigationController?.navigationBar.isTranslucent = false // 상단 네비게이션 바 반투명 제거
        
        scrollViewBackground.backgroundColor = .mainBlack
        
//        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 500)
        
        segmentedControl.addUnderlineForSelectedSegment() // segmentedControl 설정하는 메소드 호출(1)
        reviewView.alpha = 0.0 // 상세페이지 시작 시 리뷰페이지 가림.
        
        scrollViewBackgroundHeight.constant = CGFloat(Double(500) * 4) // 스크롤뷰 사이즈 - 기본.
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.introBeerDetailDataManager.getBeerDetailInfo(beerId: beerId, delegate: self) // 맥주정보 가져오는 api 호출.
    }
    
    
    @IBAction func clickWriteReviewButton(_ sender: UIButton) { // 리뷰쓰기 버튼 클릭 시,
        print("리뷰쓰기 버튼 클릭됨. (플로팅)")
        // TODO: - 리뷰쓰기 페이지 연결 작업 필요.
    }
    
    @IBAction func clickHomeButton(_ sender: UIBarButtonItem) { // 홈 버튼 클릭 시,
//        let goHome = UIStoryboard(name: "MainPageStoryboard", bundle: nil)
//        let goHomeVC = goHome.instantiateViewController(withIdentifier: "MainPageTabBarController")
//        goHomeVC.modalPresentationStyle = .fullScreen
//        self.present(goHomeVC, animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func clickSearchButton(_ sender: UIBarButtonItem) { // 검색 버튼 클릭 시,
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
 
    @IBAction func switchViews(_ sender: UISegmentedControl) { // 세그먼트 클릭 시, 뷰 변경.
        
        segmentedControl.changeUnderlinePosition() // segmentedControl 설정하는 메소드 호출(2)
        
        if sender.selectedSegmentIndex == 0 { // 맛향 탭 클릭 시, 맛향페이지 보이게 세팅. (리뷰페이지 가림)
            tasteSmellView.alpha = 1.0
            reviewView.alpha = 0.0
            scrollViewBackgroundHeight.constant = CGFloat(Double(500) * 4) // 스크롤뷰 사이즈 - 기본.
        }
        else if sender.selectedSegmentIndex == 1 { // 리뷰 탭 클릭 시, 리뷰페이지 보이게 세팅. (맛향페이지 가림)
            tasteSmellView.alpha = 0.0
            reviewView.alpha = 1.0
            
            if reviewCountSave == 0 { // 리뷰개수 0개면, 스크롤뷰 사이즈 줄일 용도로 쓰임.
                scrollViewBackgroundHeight.constant = CGFloat(Double(400) * 3) // 스크롤뷰 사이즈 - 줄임.
            }
            else { // 리뷰가 있으면, 스크롤뷰 사이즈 길게.
                scrollViewBackgroundHeight.constant = CGFloat(Double(500) * 6) // 스크롤뷰 사이즈 - 늘림.
            }
            
            
        }

    }
    
    
}



// MARK: - intro 맥주정보 GET Api
extension BeerDetailViewControllerExample {
    
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
        
        segmentedControl.setTitle("리뷰 \(result.result.reviewCount)", forSegmentAt: 1) // 리뷰 개수 텍스트 세팅
        
        reviewCountSave = result.result.reviewCount // 리뷰개수 0개면, 스크롤뷰 사이즈 줄일 용도로 쓰임.
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
