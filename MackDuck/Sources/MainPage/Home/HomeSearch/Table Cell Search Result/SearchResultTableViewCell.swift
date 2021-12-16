//
//  SearchResultTableViewCell.swift
//  MackDuck
//
//  Created by sumin on 2021/12/15.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

    static let identifier = "SearchResultTableViewCell"

    @IBOutlet weak var beerImage: UIImageView! // 맥주이미지
    @IBOutlet weak var beerNameEn: UILabel! // 맥주이름(영어)
    @IBOutlet weak var beerNameKr: UILabel! // 맥주이름(한글)
    @IBOutlet var starImages: [UIImageView]! // 별 이미지들
    @IBOutlet weak var starScore: UILabel! // 별점 점수
    @IBOutlet weak var reviewCount: UILabel! // 리뷰 개수
    
    override func prepareForReuse() { // 재사용 가능한 셀을 준비하는 메서드 - cell 중복오류 방지.
        beerImage.image = nil
        for i in 0..<starImages.count {
            starImages[i].image = UIImage(named: "searchResultStarGray.png")
        }
    }
    
    override func layoutSubviews() { // tableView cell 간 간격 설정 - https://ios-development.tistory.com/655
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "SearchResultTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
