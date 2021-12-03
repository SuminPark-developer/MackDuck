//
//  BestSearchTableViewCell.swift
//  MackDuck
//
//  Created by sumin on 2021/11/30.
//

import UIKit

class BestSearchTableViewCell: UITableViewCell {

    static let identifier = "BestSearchTableViewCell"
    @IBOutlet weak var beerImageView: UIImageView! // 맥주 이미지
    @IBOutlet weak var beerName: UILabel! // 맥주 이름
    @IBOutlet weak var beerClassification: UILabel! // 맥주 종류, 알콜도수
    @IBOutlet weak var beerFeature: UILabel! // 맥주 특징
    
    static func nib() -> UINib {
        return UINib(nibName: "BestSearchTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    public func configure(with BestSearchModel: BestSearchModel) {
        
//        self.beerImageView.image = UIImage(named: BestSearchModel.beerImageUrl)
//        self.beerImageView.contentMode = .scaleAspectFit
//
//        self.beerName.text = BestSearchModel.beerName
//
//        let beerClassAlcohol = BestSearchModel.beerKind + " / " + BestSearchModel.beerAlcohol // 맥주 종류 & 알콜 도수 text 합침.
//        self.beerClassification.text = beerClassAlcohol
//
//        self.beerFeature.text = BestSearchModel.beerFeature

//    }
    
}
