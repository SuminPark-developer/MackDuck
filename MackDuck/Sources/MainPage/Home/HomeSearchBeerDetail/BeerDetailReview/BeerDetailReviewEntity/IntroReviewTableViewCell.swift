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
    
    // TODO: - reviewTripleDot 과 reviewReportButton은 사용자 체크에 따라서 보여주는 유무가 달라지도록 구성해야 됨.
    // TODO: - 이미지뷰가 아니라, 컬렉션뷰로 바꿔야 함!
//    @IBOutlet weak var beerImage: UIImageView! // 맥주이미지
    
    @IBOutlet weak var reviewLikeButton: UIButton! // 도움이 됐어요!
    
    override func prepareForReuse() { // 재사용 가능한 셀을 준비하는 메서드 - cell 중복오류 방지.
//        beerImage.image = nil
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
