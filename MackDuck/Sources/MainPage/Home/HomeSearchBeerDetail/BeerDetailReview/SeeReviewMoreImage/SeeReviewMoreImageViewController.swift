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
    var isFirstTime: Bool = true // 첫번째일때만 전체count 저장할 변수 선언.
    var isLoading: Bool = false // 컬렉션뷰 인디케이터에 쓰임.
    var loadingView: LoadingReusableView? // 인디케이터 있는 뷰.(CollectionReusableView)
    
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
        
        // Register Loading Reuseable View
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        imageCollectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingreusableviewid")

        
        imageCollectionView.register(SeeReviewMoreImageCollectionViewCell.nib(), forCellWithReuseIdentifier: SeeReviewMoreImageCollectionViewCell.identifier) // 이미지 컬렉션뷰
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        imageCollectionView.showsHorizontalScrollIndicator = false // 컬렉션뷰 스크롤바 숨김
        imageCollectionView.showsVerticalScrollIndicator = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageResult = [] // 콜렉션 뷰 초기화.
        BeerData.details.rowNumber = "0" // 페이지 입장시 rowNumber값 초기화.
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
        imageCollectionView?.reloadData()
        
        if isFirstTime == true { // 이 화면에 들어온지 처음이라면,
            BeerData.details.seeReviewMoreImageCount = result.result.count // 서버에 있는 모든 리뷰 이미지의 개수를 저장해 놓음.
            isFirstTime = false // 이유: 맨 마지막 이미지에 도달했을 때, (imageResult데이터 개수 = 전체 개수)와 같다면 더이상 로딩할 필요 없으니깐.
        }
        
        var count: Int = 0
        for data in result.result { // 모든 이미지 배열 중 30개씩만 저장.
            imageResult.append(data)
            count = count + 1
            if count == 30 { // 30개 저장하면 break 하고, 스크롤 다 하면 또 불러와서 보여줌.
                count = 0
                break
            }
        }
        
        BeerData.details.rowNumber = imageResult.last!.rowNumber // 배열의 마지막 rowNumber를 저장.(인덱싱을 위해)
        
        
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
    

    // 컬렉션뷰 footer(인디케이터) 사이즈 설정.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading == true || imageResult.count == BeerData.details.seeReviewMoreImageCount { // 로딩중이거나 || 서버의 모든 이미지 다 불러왔다면,
            return CGSize.zero // 로딩하면 안됨.
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
    // footer(인디케이터) 배경색 등 상세 설정.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingreusableviewid", for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }
    
    // 인디케이터 로딩 애니메이션 시작. (footer appears)
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            if self.isLoading {
                self.loadingView?.activityIndicator.startAnimating()
            } else {
                self.loadingView?.activityIndicator.stopAnimating()
            }
        }
    }
    // 인디케이터 로딩 애니메이션 끝. (footer disappears)
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if imageResult.count == BeerData.details.seeReviewMoreImageCount { // 서버의 모든 이미지 다 불러왔다면,
            print("더 이상 로딩하면 X.") //  더이상 로딩하면 안됨.
        }
        else { // 서버의 모든 이미지를 다 불러온 게 아닌 상황이고,
            if indexPath.row == imageResult.count-1 && self.isLoading == false { // 사용자 스크롤이 마지막 index면서 로딩중이 아닐 때,
                loadMoreData()
                print("로딩 more Data.")
            }
        }
        
    }

    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                // Fake background loading task for 2 seconds
                sleep(2)
                // Download more data here
                DispatchQueue.main.async {
                    self.seeReviewMoreImageDataManager.getBeerReviewImageInfo(rowNumber: BeerData.details.rowNumber, beerId: BeerData.details.beerId, delegate: self) // 모든 이미지정보 가져오는 api 호출.
                    
//                    self.imageCollectionView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
}
