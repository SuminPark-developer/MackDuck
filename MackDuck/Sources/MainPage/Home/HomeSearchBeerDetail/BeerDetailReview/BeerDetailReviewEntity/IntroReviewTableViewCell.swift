//
//  IntroReviewTableViewCell.swift
//  MackDuck
//
//  Created by sumin on 2022/01/20.
//

import UIKit

class IntroReviewTableViewCell: UITableViewCell {

    static let identifier = "IntroReviewTableViewCell"
    // MARK: - BeerDetailViewControllerExample에 있는 테이블뷰의 Prototype Cell과 연결됨. - https://www.youtube.com/watch?v=l2Ld-EA9FAU
    @IBOutlet weak var reviewName: UILabel! // 박수민
    @IBOutlet weak var reviewTripleDot: UIButton! // 우측상단 점3개 버튼.
    @IBOutlet weak var reviewUserInfo: UILabel! // 나이/성별/필스너
    @IBOutlet var starImages: [UIImageView]! // 별 이미지들
    @IBOutlet weak var starScore: UILabel! // 별점 점수
    @IBOutlet weak var reviewDate: UILabel! // 2022.03.06 수정됨
    @IBOutlet weak var reviewReportButton: UIButton! // 신고하기 버튼.
    @IBOutlet weak var reviewDescription: UILabel! // 리뷰 내용 - ex) 생각보다 에일의 쓴맛이 덜합니다 ...
    // TODO: - 이미지뷰가 아니라, 컬렉션뷰로 바꿔야 함!
    @IBOutlet weak var reviewCollectionView: UICollectionView! // 맥주이미지 컬렉션뷰
    @IBOutlet weak var reviewLikeButton: UIButton! // 도움이 됐어요!
    
    var introReviewModels: IntroReviewModel? // 리뷰 안에 있는 컬렉션뷰의 이미지를 채우기 위한 데이터 전달받기 위해 선언한 변수.
    
    override func prepareForReuse() { // 재사용 가능한 셀을 준비하는 메서드 - cell 중복오류 방지.
//        reviewCollectionView = nil
        reviewCollectionView.reloadData()
//        reviewCollectionView.isHidden = true
        for i in 0..<starImages.count {
            starImages[i].image = UIImage(named: "searchResultStarGray.png")
        }
    }
    
//    override func layoutSubviews() { // tableView cell 간 간격 설정 - https://ios-development.tistory.com/655
//        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
//    }
    
    static func nib() -> UINib {
        return UINib(nibName: "IntroReviewTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 90, height: 80)
        reviewCollectionView.collectionViewLayout = layout // 셀 크기 지정 - https://k-elon.tistory.com/26
        
        reviewCollectionView.register(IntroReviewCollectionViewCell.nib(), forCellWithReuseIdentifier: IntroReviewCollectionViewCell.identifier) // 리뷰에 있는 컬렉션뷰
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        
        reviewCollectionView.showsHorizontalScrollIndicator = false // 컬렉션뷰 스크롤바 숨김
        reviewCollectionView.showsVerticalScrollIndicator = false
        
    }

    func configure(with introReviewModels: IntroReviewModel) { // 리뷰에 있는 컬렉션뷰
        self.introReviewModels = introReviewModels
//        collectionView.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickLikeButton(_ sender: UIButton) {
        // TODO: - 도움이 됐어요 api 작업 필요.
        // TODO: - 글자 증가 작업 필요.
        print("도움이 됐어요 클릭.")
    }
    
    @IBAction func clickTripleDot(_ sender: UIButton) {
        // TODO: - 점3개 api 작업 필요.
        print("점3개 클릭.")

    }
    
    @IBAction func clickReportButton(_ sender: UIButton) {
        // TODO: - 신고버튼 api 작업 필요.
        print("신고버튼 클릭.")

    }
}

// MARK: - 리뷰 안에 있는 CollectionView
extension IntroReviewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if introReviewModels?.reviewImgUrlList.count == 0 { // 컬렉션뷰에 들어갈 이미지 데이터가 0개라면,
            return 0
        }
        else { // 컬렉션뷰에 들어갈 이미지 데이터가 0개가 아니라면,
            return (introReviewModels?.reviewImgUrlList.count)! // 컬렉션뷰에 들어갈 이미지 개수 반환
        }
    }
        
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IntroReviewCollectionViewCell.identifier, for: indexPath) as! IntroReviewCollectionViewCell
//        cell.collectionImageView.image = nil
        
//        cell.configure(with: introReviewModels!)
        cell.configure(with: BeerData.details.introReviewModel!)
        
        return cell
    }
    
    // 컬렉션뷰 사이즈 설정
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // 컬렉션뷰 클릭 -> inspector에서 Min Spacing을 0으로 바꿔주면 됨. -  https://stackoverflow.com/questions/28325277/how-to-set-cell-spacing-and-uicollectionview-uicollectionviewflowlayout-size-r
//        return CGSize(width: 88, height: 88) // 각 cell 3만큼 공백 줌.
//    }
    

    
}
