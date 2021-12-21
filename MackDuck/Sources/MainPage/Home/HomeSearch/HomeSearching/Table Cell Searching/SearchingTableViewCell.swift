//
//  SearchingTableViewCell.swift
//  MackDuck
//
//  Created by sumin on 2021/12/21.
//

import UIKit

class SearchingTableViewCell: UITableViewCell {

    static let identifier = "SearchingTableViewCell"
    @IBOutlet weak var beerName: UILabel! // 한글+영어
    
    override func prepareForReuse() { // 재사용 가능한 셀을 준비하는 메서드 - cell 중복오류 방지.
        beerName.text = nil
    }

//    override func layoutSubviews() { // tableView cell 간 간격 설정 - https://ios-development.tistory.com/655
//        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
//    }
    
    static func nib() -> UINib {
        return UINib(nibName: "SearchingTableViewCell", bundle: nil)
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
