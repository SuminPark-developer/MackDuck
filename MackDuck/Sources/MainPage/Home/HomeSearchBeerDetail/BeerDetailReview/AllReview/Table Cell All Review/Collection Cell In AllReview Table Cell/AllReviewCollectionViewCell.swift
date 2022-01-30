//
//  AllReviewCollectionViewCell.swift
//  MackDuck
//
//  Created by sumin on 2022/01/28.
//

import UIKit

class AllReviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionImageView: UIImageView!
    
    static let identifier = "AllReviewCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "AllReviewCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionImageView.image = nil
//        collectionImageView.isHidden = true
    }

    public func configure(with imageUrl: AllReviewImgUrlList) {
        
        let url = URL(string: imageUrl.reviewImageUrl) // url 값 저장.
        // DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
        DispatchQueue.global(qos: .background).async { // DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.collectionImageView.image = UIImage(data: data!) // 만약 url이 없다면(안 들어온다면) try-catch로 확인해줘야 함.
    //                    self.collectionImageView.contentMode = .scaleAspectFit
                self.collectionImageView.contentMode = .scaleAspectFill
            }
        }
        
    }
}
