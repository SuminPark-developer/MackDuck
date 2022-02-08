//
//  ReviewDetailViewController.swift
//  MackDuck
//
//  Created by sumin on 2022/02/08.
//

import UIKit

class ReviewDetailViewController: UIViewController {
    var reviewDetailDataManager: ReviewDetailDataManager = ReviewDetailDataManager() // 리뷰 정보(1개) 가져오는 dataManager
    var reviewDetailLikeButtonDataManager: ReviewDetailLikeButtonDataManager = ReviewDetailLikeButtonDataManager() // 도움이 됐어요 dataManager
    var navTitle: String = ""
    var reviewId: Int = 0
    
    @IBOutlet weak var navigationBarItem: UINavigationItem! // 상단 네비게이션바 아이템
    
    @IBOutlet weak var reviewName: UILabel! // 박수민
    @IBOutlet weak var reviewTripleDot: UIButton! // 우측상단 점3개 버튼.
    @IBOutlet weak var reviewUserInfo: UILabel! // 나이/성별/필스너
    @IBOutlet var starImages: [UIImageView]! // 별 이미지들
    @IBOutlet weak var starScore: UILabel! // 별점 점수
    @IBOutlet weak var reviewDate: UILabel! // 2022.03.06 수정됨
    @IBOutlet weak var reviewReportButton: UIButton! // 신고하기 버튼.
    @IBOutlet weak var reviewDescription: UILabel! // 리뷰 내용 - ex) 생각보다 에일의 쓴맛이 덜합니다 ...
    @IBOutlet weak var reviewCollectionView: UICollectionView! // 맥주이미지 컬렉션뷰
    @IBOutlet weak var reviewLikeButton: UIButton! // 도움이 됐어요!
    
    var reviewDetailImageUrl: [ReviewDetailImgUrlList] = [] // 리뷰(1개) 이미지 데이터
    var saveReviewLikeCount: Int = 0 // 좋아요 개수 저장 -> 좋아요 버튼 클릭 시 값 증감.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationBarItem.title = navTitle
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Regular", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.mainWhite]

        self.view.backgroundColor = .mainBlack
        self.navigationController?.navigationBar.backgroundColor = .mainBlack // 이걸 해줘야 네비게이션바 색 바뀌는듯.
        self.navigationController?.navigationBar.barTintColor = .mainBlack // 상단 네비게이션 바 색상 변경
        self.navigationController?.navigationBar.isTranslucent = false // 상단 네비게이션 바 반투명 제거
        
        // collectionview cell 설정 부분.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 90, height: 80)

        reviewCollectionView.collectionViewLayout = layout // 셀 크기 지정 - https://k-elon.tistory.com/26
        
        reviewCollectionView.register(ReviewDetailCollectionViewCell.nib(), forCellWithReuseIdentifier: ReviewDetailCollectionViewCell.identifier) // 리뷰에 있는 컬렉션뷰
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        
        reviewCollectionView.showsHorizontalScrollIndicator = false // 컬렉션뷰 스크롤바 숨김
        reviewCollectionView.showsVerticalScrollIndicator = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reviewDetailDataManager.getReviewDetail(reviewId: reviewId, delegate: self) // 맥주 리뷰 정보(1개) 가져오는 api 호출.
    }
    
    @IBAction func clickReportButton(_ sender: UIButton) { // 신고하기 버튼 클릭 시, 팝업창 띄움.
        let popup = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        let goPopupVC = popup.instantiateViewController(withIdentifier: "AllReviewReportPopupVC") as! AllReviewReportPopupViewController
        goPopupVC.reviewId = reviewId // IntroReviewTableViewCell에서 reviewId를 가져와 팝업뷰에 전달.
        goPopupVC.modalPresentationStyle = .overCurrentContext //  투명도가 있으면 투명도에 맞춰서 나오게 해주는 코드(뒤에있는 배경이 보일 수 있게)
        self.present(goPopupVC, animated: false, completion: nil)
    }
    
    @IBAction func clickTripleDotButton(_ sender: UIButton) { // 점3개 버튼 클릭 시, 커스텀ActionSheet(popup) 띄움.
        let tripleDotPopup = UIStoryboard(name: "HomeStoryboard", bundle: nil)
        let goTripleDotPopupVC = tripleDotPopup.instantiateViewController(withIdentifier: "TripleDotPopupVC") as! TripleDotPopupViewController
        goTripleDotPopupVC.reviewId = reviewId // IntroReviewTableViewCell에서 reviewId를 가져와 팝업뷰에 전달.
        goTripleDotPopupVC.modalPresentationStyle = .overCurrentContext // 투명도가 있으면 투명도에 맞춰서 나오게 해주는 코드(뒤에있는 배경이 보일 수 있게)
        self.present(goTripleDotPopupVC, animated: false, completion: nil)
    }
    
    @IBAction func clickLikeButton(_ sender: UIButton) { // 도움이 됐어요! 버튼 클릭 시,
        let userId = UserDefaults.standard.integer(forKey: "userId") // UserDefaults에서 userId값 불러옴.
        self.reviewDetailLikeButtonDataManager.postIntroReviewLike(userId: userId, reviewId: reviewId, delegate: self) // 도움이됐어요 정보 가져오는 api 호출.
    }
    
    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

}


// MARK: - 리뷰사진더보기-리뷰보러가기 : 리뷰 정보(1개) GET Api
extension ReviewDetailViewController {
    
    // MARK: - 리뷰 있을 때,
    func didSuccessGetReviewDetail(_ result: ReviewDetailResponse) { // reviewId가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에서 리뷰 ui 작업.
        print("서버로부터 맥주 리뷰 정보(1개) GET 성공!")
        print("response 내용 : \(result)")
        

        let beerKindDict: [Int: String] = [1: "라거", 2: "필스너", 3: "둔켈", 4: "에일", 5: "IPA", 6: "밀맥주", 7: "스타우트", 8: "포터"]
        let beerKindString: String = beerKindDict[result.result.beerKindId]!
        
        reviewDetailImageUrl = result.result.reviewImgUrlList // 이미지 url들 저장.
        for temp in reviewDetailImageUrl {
            print("HHAHAHAHAHAAHAHAHAHAHAHAHAHAHAHHA")
            print(temp.reviewImageUrl)
        }
        // api 데이터 가져온거로 모든 이미지(컬렉션뷰) ui 구성.
        reviewCollectionView?.reloadData()
        
        
        reviewName.text = result.result.nickname // ex) 박수민
        reviewUserInfo.text = "\(result.result.age)/\(result.result.gender)/\(beerKindString)"
        
        if result.result.userCheck == "Y" { // 본인의 리뷰라면,
            reviewTripleDot.isHidden = false // (우측상단) 점 3개 보이게.
            reviewReportButton.isHidden = true // (우측중단) 신고하기 버튼 안보이게.
        }
        else { // 본인의 리뷰가 아니라면,
            reviewTripleDot.isHidden = true // (우측상단) 점 3개 안보이게.
            reviewReportButton.isHidden = false // (우측중단) 신고하기 버튼 보이게.
        }

        starScore.text = String(result.result.score) // ex) 4(리뷰 점수)
        

        // 소수점 score를 정수로 바꾸고 그 점수까지 스타 yellow이미지로 바꾸게 함. - 여기선 score가 이미 Int라서 안해도 되긴 함.
        let score: Int = Int(floor(Double(result.result.score)))
        for i in 0..<score {
            starImages[i].image = UIImage(named: "searchResultStarYellow.png")
        }

        reviewDescription.text = result.result.description // 리뷰 내용 - ex) 생각보다 에일의 쓴맛이 덜합니다
        reviewDate.text = result.result.updatedAt // 날짜 - 2022.03.06
        
        
        self.saveReviewLikeCount = result.result.reviewLikeCount // 좋아요개수 저장. - 좋아요 버튼 클릭 시 값 증감.
        
        let reviewLikeCountText = String(saveReviewLikeCount) // 도움이 됐어요!버튼의 좋아요 개수부분 text bold처리.
        let text: String = "도움이 됐어요! \(reviewLikeCountText)"
        let attributeString = NSMutableAttributedString(string: text)
        let font1 = UIFont(name: "NotoSansKR-Regular", size: 12) // 도움이됐어요!부분 폰트
        let font2 = UIFont(name: "Montserrat-Bold", size: 12) // 숫자부분 폰트
        attributeString.addAttribute(.font, value: font1!, range: (text as NSString).range(of: "도움이 됐어요! "))
        attributeString.addAttribute(.font, value: font2!, range: (text as NSString).range(of: "\(reviewLikeCountText)"))
        reviewLikeButton.setAttributedTitle(attributeString, for: .normal)
        
    }

    // MARK: - 리뷰 없을 때,
    func failedToGetReviewDetail(message: String, code: Int) { // 해당 상품에 관한 리뷰가 없을 때
        print("리뷰가 없음 - 리뷰 GET 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
        }
        else if code == 3010 { // 실패 이유 : "해당 상품에 관한 리뷰가 없습니다."
            
        }
    }
    
}

// MARK: - 리뷰 안에 있는 CollectionView
extension ReviewDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewDetailImageUrl.count // 컬렉션뷰에 들어갈 이미지 개수 반환
    }
        
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewDetailCollectionViewCell.identifier, for: indexPath) as! ReviewDetailCollectionViewCell
        
        cell.configure(with: reviewDetailImageUrl[indexPath.row])
        
        return cell
    }
    
    // 컬렉션뷰 사이즈 설정
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // 컬렉션뷰 클릭 -> inspector에서 Min Spacing을 0으로 바꿔주면 됨. -  https://stackoverflow.com/questions/28325277/how-to-set-cell-spacing-and-uicollectionview-uicollectionviewflowlayout-size-r
//        return CGSize(width: 88, height: 88) // 각 cell 3만큼 공백 줌.
//    }
    

    
}

// MARK: - 리뷰사진더보기-리뷰보러가기 좋아요 정보 POST Api
extension ReviewDetailViewController {
    
    // MARK: - 좋아요 정보 POST 성공할 때,
    func didSuccessPostReviewLike(_ result: ReviewDetailLikeButtonResponse) { // userId, reviewId가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에서 리뷰 ui 작업.
        print("리뷰사진더보기-리뷰보러가기 리뷰 : 좋아요 정보 서버에 POST 성공!")
        print("response 내용 : \(result)")
        
        if result.message == "도움이 됐어요 추가 성공" || result.message == "도움이 됐어요 추가(ACTIVE로 수정) 성공" {
            saveReviewLikeCount = saveReviewLikeCount + 1 // 좋아요 개수 증가.
        }
        else if result.message == "도움이 됐어요 삭제(INACTIVE로 수정) 성공" {
            saveReviewLikeCount = saveReviewLikeCount - 1 // 좋아요 개수 감소.
        }
        let reviewLikeCountText = String(saveReviewLikeCount) // 도움이 됐어요!버튼의 좋아요 개수부분 text bold처리.
        let text: String = "도움이 됐어요! \(reviewLikeCountText)"
        let attributeString = NSMutableAttributedString(string: text)
        let font1 = UIFont(name: "NotoSansKR-Regular", size: 12) // 도움이됐어요!부분 폰트
        let font2 = UIFont(name: "Montserrat-Bold", size: 12) // 숫자부분 폰트
        attributeString.addAttribute(.font, value: font1!, range: (text as NSString).range(of: "도움이 됐어요! "))
        attributeString.addAttribute(.font, value: font2!, range: (text as NSString).range(of: "\(reviewLikeCountText)"))
        reviewLikeButton.setAttributedTitle(attributeString, for: .normal)
        
    }

    // MARK: - 좋아요 정보 POST 실패할 때,
    func failedToPostReviewLike(message: String, code: Int) { // 좋아요 정보 POST 실패할 때
        print("intro 리뷰 cell 좋아요 정보 POST 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
        }
        else if code == 3024 { // 실패 이유 : "좋아요 누를 리뷰가 존재하지 않습니다."
            
        }
    }
    
}
