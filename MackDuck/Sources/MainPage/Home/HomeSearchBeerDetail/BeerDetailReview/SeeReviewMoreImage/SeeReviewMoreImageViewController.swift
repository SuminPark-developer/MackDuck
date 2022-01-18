//
//  SeeReviewMoreImageViewController.swift
//  MackDuck
//
//  Created by sumin on 2022/01/17.
//

import UIKit

class SeeReviewMoreImageViewController: UIViewController {

    var seeReviewMoreImageDataManager: SeeReviewMoreImageDataManager = SeeReviewMoreImageDataManager() // 더보기버튼 - 모든 이미지정보 가져오는 dataManager
    var imageResult: [SeeReviewMoreImageResult] = [] // 이미지 string 저장해놓을 배열 선언.
    
    @IBOutlet weak var navigationBarItem: UINavigationItem! // 상단 네비게이션바 아이템
    @IBOutlet weak var imageCollectionView: UICollectionView! // 이미지 컬렉션뷰
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarItem.title = "사진 모아보기"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Regular", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.mainWhite]

        
        self.view.backgroundColor = .mainBlack
        self.navigationController?.navigationBar.backgroundColor = .mainBlack // 이걸 해줘야 네비게이션바 색 바뀌는듯.
        self.navigationController?.navigationBar.barTintColor = .mainBlack // 상단 네비게이션 바 색상 변경
        self.navigationController?.navigationBar.isTranslucent = false // 상단 네비게이션 바 반투명 제거
        
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width-12)/3, height: UIScreen.main.bounds.width/3)
//        layout.minimumInteritemSpacing = 6
//        layout.minimumLineSpacing = 0
//        imageCollectionView!.collectionViewLayout = layout
        
        imageCollectionView.register(SeeReviewMoreImageCollectionViewCell.nib(), forCellWithReuseIdentifier: SeeReviewMoreImageCollectionViewCell.identifier) // 이미지 컬렉션뷰
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        imageCollectionView.showsHorizontalScrollIndicator = false // 컬렉션뷰 스크롤바 숨김
        imageCollectionView.showsVerticalScrollIndicator = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.seeReviewMoreImageDataManager.getBeerReviewImageInfo(rowNumber: BeerData.details.rowNumber, beerId: BeerData.details.beerId, delegate: self) // 모든 이미지정보 가져오는 api 호출.
    }
    
    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }


}


// MARK: - 맥주 리뷰 모든 이미지 GET Api
extension SeeReviewMoreImageViewController {
    
    func didSuccessGetBeerReviewImageInfo(_ result: SeeReviewMoreImageResponse) { // beerId가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에서 모든 이미지 ui 작업.
        print("서버로부터 맥주 리뷰 - 모든 이미지 GET 성공!")
        print("response 내용 : \(result)")
        
        // api 데이터 가져온거로 모든 이미지(컬렉션뷰) ui 구성.
       
        imageResult = [] // 콜렉션 뷰 초기화
        imageCollectionView?.reloadData()
        imageResult = result.result // 모든 이미지 배열에 저장.
        
//        print("################# 값 변경 전 : \(BeerData.details.rowNumber)#####################")
//        BeerData.details.rowNumber = result.result[0].rowNumber
//        print("################# 값 변경 후 : \(BeerData.details.rowNumber)#####################")
        
        
    }

    func failedToGetBeerReviewImageInfo(message: String, code: Int) { // 오류메시지 & code번호 몇인지
        print("리뷰 정보 GET 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
        }
        else if code == 3010 { // 실패 이유 : "해당 상품에 관한 리뷰가 없습니다."
            
        }
    }
    
}

// MARK: - CollectionView
extension SeeReviewMoreImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageResult.count // 이미지 컬렉션뷰
    }
        
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeeReviewMoreImageCollectionViewCell.identifier, for: indexPath) as! SeeReviewMoreImageCollectionViewCell
        let imageUrlString = imageResult[indexPath.row].reviewImgUrl
        
        cell.configure(with: imageUrlString)
        
        return cell
    }
    
    // 사진 클릭시 (확대된) 다음 페이지로 넘어가는 함수.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) 클릭.")
        let imageUrlString = imageResult[indexPath.row].reviewImgUrl // 컬렉션뷰 cell의 데이터 → 새로운 VC에 전달하는 방법. -  https://stackoverflow.com/questions/41831994/how-to-pass-collection-view-data-to-a-new-view-controller

        let imageDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageDetailVC") as? ImageDetailViewController
        imageDetailVC?.navTitle = "\(indexPath.row + 1) / \(imageResult.count)"
        imageDetailVC!.imageUrlString = imageUrlString
        self.navigationController?.pushViewController(imageDetailVC!, animated: true)
        
    }
    
    // 컬렉션뷰 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 컬렉션뷰 클릭 -> inspector에서 Min Spacing을 0으로 바꿔주면 됨. -  https://stackoverflow.com/questions/28325277/how-to-set-cell-spacing-and-uicollectionview-uicollectionviewflowlayout-size-r
        return CGSize(width: UIScreen.main.bounds.width/3-3, height: UIScreen.main.bounds.width/3) // 각 cell 3만큼 공백 줌.
    }
    
    
}
