//
//  AllReviewTableViewCell.swift
//  MackDuck
//
//  Created by sumin on 2022/01/28.
//

import UIKit

class AllReviewTableViewCell: UITableViewCell {

    var allReviewLikeButtonDataManager: AllReviewLikeButtonDataManager = AllReviewLikeButtonDataManager() // 모든 리뷰 - 좋아요 정보 보내는 dataManager
    
    static let identifier = "AllReviewTableViewCell"
    // MARK: - AllReviewViewControllerExample에 있는 테이블뷰의 Prototype Cell과 연결됨. - https://www.youtube.com/watch?v=l2Ld-EA9FAU
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
    
    var imageModel = [AllReviewImgUrlList]() // 리뷰 안에 있는 컬렉션뷰의 이미지를 채우기 위한 데이터 전달받기 위해 선언한 변수.
    var reviewId: Int = 0 // 좋아요 버튼 클릭 시 api 연결을 위해 선언한 변수.
    var saveReviewLikeCount: Int = 0 // 좋아요 개수 저장 -> 좋아요 버튼 클릭 시 값 증감.
    
    var delegate: AllReviewTableViewCellDelegate?
    
    override func prepareForReuse() { // 재사용 가능한 셀을 준비하는 메서드 - cell 중복오류 방지.
        for i in 0..<starImages.count {
            starImages[i].image = UIImage(named: "searchResultStarGray.png")
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "AllReviewTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 90, height: 80)

        reviewCollectionView.collectionViewLayout = layout // 셀 크기 지정 - https://k-elon.tistory.com/26
        
        reviewCollectionView.register(AllReviewCollectionViewCell.nib(), forCellWithReuseIdentifier: AllReviewCollectionViewCell.identifier) // 리뷰에 있는 컬렉션뷰
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        
        reviewCollectionView.showsHorizontalScrollIndicator = false // 컬렉션뷰 스크롤바 숨김
        reviewCollectionView.showsVerticalScrollIndicator = false
        
    }
    
    func configure(with allReviewModel: AllReviewModel) { // 리뷰에 있는 컬렉션뷰
        self.imageModel = allReviewModel.reviewImgUrlList // 컬렉션뷰 이미지 리스트 저장.
        self.reviewId = allReviewModel.reviewId // 리뷰아이디 저장. - 좋아요 버튼 api에 필요.
        self.saveReviewLikeCount = allReviewModel.reviewLikeCount // 좋아요개수 저장. - 좋아요 버튼 클릭 시 값 증감.
        
        let reviewLikeCountText = String(saveReviewLikeCount) // 도움이 됐어요!버튼의 좋아요 개수부분 text bold처리.
        let text: String = "도움이 됐어요! \(reviewLikeCountText)"
        let attributeString = NSMutableAttributedString(string: text)
        let font1 = UIFont(name: "NotoSansKR-Regular", size: 12) // 도움이됐어요!부분 폰트
        let font2 = UIFont(name: "Montserrat-Bold", size: 12) // 숫자부분 폰트
        attributeString.addAttribute(.font, value: font1!, range: (text as NSString).range(of: "도움이 됐어요! "))
        attributeString.addAttribute(.font, value: font2!, range: (text as NSString).range(of: "\(reviewLikeCountText)"))
        reviewLikeButton.setAttributedTitle(attributeString, for: .normal)
        
        reviewCollectionView.reloadData() // 컬렉션뷰 reloadData() 안해주면 cell 뒤죽박죽됨. - prepareForReuse에 있어도 되긴 함.
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickLikeButton(_ sender: UIButton) {
        print("도움이 됐어요(좋아요) 클릭.")
        
        let userId = UserDefaults.standard.integer(forKey: "userId") // UserDefaults에서 userId값 불러옴.
        self.allReviewLikeButtonDataManager.postAllReviewLike(userId: userId, reviewId: reviewId, delegate: self) // 모든 리뷰 - 좋아요 정보 보내는 api 호출.
    }
    
    @IBAction func clickTripleDot(_ sender: UIButton) {
        print("점3개 클릭.")
        delegate?.didTripleDotPressed(reviewId: reviewId) // AllReviewViewController에 있는 didTripleDotPressed메서드 호출. -> 커스텀ActionSheet창 띄움.
    }
    
    @IBAction func clickReportButton(_ sender: UIButton) {
        print("신고버튼 클릭.")
        delegate?.didReportButtonPressed(reviewId: reviewId) // AllReviewViewController에 있는 didReportButtonPressed메서드에 reviewId전달. -> 팝업뷰에 reviewId전달.
    }

}
// MARK: - delegate 패턴 사용 : https://stackoverflow.com/questions/48334292/swift-how-call-uiviewcontroller-from-a-button-in-uitableviewcell
protocol AllReviewTableViewCellDelegate {
    func didReportButtonPressed(reviewId: Int) // 신고버튼 클릭 - AllReviewViewController에 있음.(팝업창 띄움.)
    func didTripleDotPressed(reviewId: Int) // 점3개버튼 클릭 - AllReviewViewController에 있음.(커스텀ActionSheet 띄움.)
}

// MARK: - 모든 리뷰 : 좋아요 정보 POST Api
extension AllReviewTableViewCell {
    
    // MARK: - 좋아요 정보 POST 성공할 때,
    func didSuccessPostAllReviewLike(_ result: AllReviewLikeButtonResponse) { // userId, reviewId가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에서 리뷰 ui 작업.
        print("모든 리뷰 : 좋아요 정보 서버에 POST 성공!")
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
    func failedToPostAllReviewLike(message: String, code: Int) { // 좋아요 정보 POST 실패할 때
        print("좋아요 정보 POST 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
        }
        else if code == 3024 { // 실패 이유 : "좋아요 누를 리뷰가 존재하지 않습니다."
            
        }
    }
    
}

// MARK: - 리뷰 안에 있는 CollectionView
extension AllReviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageModel.count // 컬렉션뷰에 들어갈 이미지 개수 반환.
    }
        
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllReviewCollectionViewCell.identifier, for: indexPath) as! AllReviewCollectionViewCell
        
        cell.configure(with: imageModel[indexPath.row])
        
        return cell
    }
    
    // 컬렉션뷰 사이즈 설정
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // 컬렉션뷰 클릭 -> inspector에서 Min Spacing을 0으로 바꿔주면 됨. -  https://stackoverflow.com/questions/28325277/how-to-set-cell-spacing-and-uicollectionview-uicollectionviewflowlayout-size-r
//        return CGSize(width: 88, height: 88) // 각 cell 3만큼 공백 줌.
//    }
    

    
}
