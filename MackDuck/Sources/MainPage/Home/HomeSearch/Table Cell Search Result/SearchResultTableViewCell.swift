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
