//
//  AllReviewViewController.swift
//  MackDuck
//
//  Created by sumin on 2022/01/28.
//

import UIKit

class AllReviewViewController: UIViewController {

    var allReviewDataManager: AllReviewDataManager = AllReviewDataManager() // 모든 리뷰 정보 가져오는 dataManager
    var allReviewList: [AllReviewModel] = [] // 모든 리뷰 데이터(모델)들
    var isFirstTime: Bool = true // 첫번째일때만 전체리뷰 count 저장할 변수 선언.
    var isLoading: Bool = false // 테이블뷰 로딩 인디케이터에 쓰임.
    
    @IBOutlet weak var reviewCountLabel: UILabel! // 리뷰 개수 라벨.
    @IBOutlet weak var allReviewTableView: UITableView! // 전체 리뷰 테이블뷰.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "NotoSansKR-Regular", size: 14)!, NSAttributedString.Key.foregroundColor: UIColor.mainWhite] // 네비게이션 타이틀 색 변경

        
        self.view.backgroundColor = .mainBlack
        self.navigationController?.navigationBar.backgroundColor = .mainBlack // 이걸 해줘야 네비게이션바 색 바뀌는듯.
        self.navigationController?.navigationBar.barTintColor = .mainBlack // 상단 네비게이션 바 색상 변경
        self.navigationController?.navigationBar.isTranslucent = false // 상단 네비게이션 바 반투명 제거
        
        allReviewTableView.delegate = self
        allReviewTableView.dataSource = self
        
        // Register Loading Cell
        let tableViewLoadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        self.allReviewTableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: "loadingcellid")
        
    }
    

    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        allReviewList = []
        BeerData.details.seeAllReviewRowNumber = "0" // 페이지 입장시 rowNumber값 초기화.
        self.allReviewDataManager.getAllReview(rowNumber: BeerData.details.seeAllReviewRowNumber, beerId: BeerData.details.beerId, delegate: self) // 모든 맥주 리뷰 정보 가져오는 api 호출
    }

}




// MARK: - 맥주 모든 리뷰 정보 GET Api
extension AllReviewViewController {
    
    // MARK: - 리뷰 있을 때,
    func didSuccessGetAllReview(_ result: AllReviewResponse) { // beerId가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에서 리뷰 ui 작업.
        print("서버로부터 맥주 모든 리뷰 정보 GET 성공!")
        print("response 내용 : \(result)")
        
        if isFirstTime == true { // 이 화면에 들어온지 처음이라면,
            BeerData.details.seeAllReviewCount = result.result.reviewCount // 서버에 있는 모든 리뷰의 개수를 저장해 놓음.(무한스크롤을 위해)
            isFirstTime = false // 이유: 맨 마지막 이미지에 도달했을 때, (allReviewList데이터 개수 = 전체 개수)와 같다면 더이상 로딩할 필요 없으니깐.
        }
        
        // api 데이터 가져온거로 리뷰 ui 구성.
        reviewCountLabel.text = String(result.result.reviewCount)
        
//        allReviewList.removeAll() // 전체리뷰 - 담는 리스트의 모든 element들을 지워줘야 함. (안 지우면 계속 데이터 남아있어서 결과가 쌓임)
        
        
        var count: Int = 0
        for reviewData in result.result.reviewList { // 가져온 값들을 allReviewList에 데이터 넣음.
            self.allReviewList.append(AllReviewModel(userCheck: reviewData.userCheck, reviewId: reviewData.reviewId, nickname: reviewData.nickname, age: reviewData.age, gender: reviewData.gender, beerKindId: reviewData.beerKindId, score: reviewData.score, updatedAt: reviewData.updatedAt, description: reviewData.description, reviewLikeCount: reviewData.reviewLikeCount, rowNumber: reviewData.rowNumber, reviewImgUrlList: reviewData.reviewImgUrlList)) // 리뷰 cell 정보 전체적으로 저장.
            
            count = count + 1
            if count == 3 { // 3개 저장하면 break 하고, 스크롤 다 하면 또 불러와서 보여줌.
                count = 0
                break
            }
            
        }
        
        BeerData.details.seeAllReviewRowNumber = allReviewList.last!.rowNumber // 배열의 마지막 rowNumber를 저장.(인덱싱을 위해)
        
        self.allReviewTableView.reloadData() // 테이블뷰 .reloadData()를 해줘야 데이터가 반영됨.
        
        
    }

    // MARK: - 리뷰 없을 때,
    func failedToGetAllReview(message: String, code: Int) { // 해당 상품에 관한 리뷰가 없을 때
        print("리뷰가 없음 - 리뷰 GET 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
        }
        else if code == 3010 { // 실패 이유 : "해당 상품에 관한 리뷰가 없습니다."
            
        }
    }
    
}

// MARK: - 하단 intro 리뷰(6개) 테이블뷰 부분
extension AllReviewViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("리뷰 개수 테스트 : \(allReviewList.count)")
//        return allReviewList.count // 리뷰 개수만큼 return.
        
        if section == 0 {
            return allReviewList.count // 리뷰 개수만큼 return.
        }
        else if section == 1 {
            return 1 // Return the Loading cell
        }
        else {
            return 0 // Return nothing
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 { // 리뷰cell일 땐,
            let cell = tableView.dequeueReusableCell(withIdentifier: "allReviewCell", for: indexPath) as! AllReviewTableViewCell
            let allReviewModel: AllReviewModel = allReviewList[indexPath.row]
            
            cell.configure(with: allReviewModel) // 리뷰안에 있는 컬렉션뷰에 데이터 전달. (컬렉션뷰 연결 작업)

            let beerKindDict: [Int: String] = [1: "라거", 2: "필스너", 3: "둔켈", 4: "에일", 5: "IPA", 6: "밀맥주", 7: "스타우트", 8: "포터"]
            let beerKindString: String = beerKindDict[allReviewModel.beerKindId]!
            
            cell.reviewName.text = allReviewModel.nickname // ex) 박수민
            cell.reviewUserInfo.text = "\(allReviewModel.age)/\(allReviewModel.gender)/\(beerKindString)"
            
            if allReviewModel.userCheck == "Y" { // 본인의 리뷰라면,
                cell.reviewTripleDot.isHidden = false // (우측상단) 점 3개 보이게.
                cell.reviewReportButton.isHidden = true // (우측중단) 신고하기 버튼 안보이게.
            }
            else { // 본인의 리뷰가 아니라면,
                cell.reviewTripleDot.isHidden = true // (우측상단) 점 3개 안보이게.
                cell.reviewReportButton.isHidden = false // (우측중단) 신고하기 버튼 보이게.
            }

            cell.starScore.text = String(allReviewModel.score) // ex) 4(리뷰 점수)
            

            // 소수점 score를 정수로 바꾸고 그 점수까지 스타 yellow이미지로 바꾸게 함. - 여기선 score가 이미 Int라서 안해도 되긴 함.
            let score: Int = Int(floor(Double(allReviewModel.score)))
            for i in 0..<score {
                cell.starImages[i].image = UIImage(named: "searchResultStarYellow.png")
            }

            cell.reviewDescription.text = allReviewModel.description // 리뷰 내용 - ex) 생각보다 에일의 쓴맛이 덜합니다
            cell.reviewDate.text = allReviewModel.updatedAt // 날짜 - 2022.03.06
            
            cell.selectionStyle = .none // 테이블뷰 cell 선택시 배경색상 없애기 : https://gonslab.tistory.com/41 | https://sweetdev.tistory.com/105

            return cell
        }
        else { // 로딩 cell일 땐,
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingcellid", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        }
        
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == allReviewTableView {
            print(allReviewList[indexPath.row].description)
            
//            BeerData.details.beerId = SearchResultList[indexPath.row].beerId // 맥주 beerId 저장. -> 맛향 VC에서 사용함.
            
            // 맥주 상세 설명 페이지로 연결.
//            let beerDetailVC = (self.storyboard?.instantiateViewController(withIdentifier: "BeerDetailVC")) as! BeerDetailViewController
//            beerDetailVC.beerId = SearchResultList[indexPath.row].beerId
//            self.navigationController?.pushViewController(beerDetailVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 380 // 기존 cell 높이 return.
        
        if indexPath.section == 0 { // 기존 cell 높이 return.
            return 380
        }
        else { // 로딩 cell일 때,
            if allReviewList.count == BeerData.details.seeAllReviewCount { // 서버의 모든 리뷰 다 불러왔다면,
                print("더 이상 로딩하면 X.") //  더이상 로딩하면 안됨.
                return 0 // 로딩 cell 높이 없앰.
            }
            else {
                return 55 // 로딩 cell 높이 return.
            }
            
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if allReviewList.count == BeerData.details.seeAllReviewCount { // 서버의 모든 리뷰 다 불러왔다면,
//            print("더 이상 로딩하면 X.") //  더이상 로딩하면 안됨.
        }
        else { // 서버의 모든 리뷰를 다 불러온 게 아닌 상황이고,
            if (offsetY > contentHeight - scrollView.frame.height * 4) && self.isLoading == false { // 사용자 스크롤이 끝에 도달하면서 로딩중이 아닐 때,
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
                    self.allReviewDataManager.getAllReview(rowNumber: BeerData.details.seeAllReviewRowNumber, beerId: BeerData.details.beerId, delegate: self) // 모든 맥주 리뷰 정보 가져오는 api 호출
                    
//                    self.allReviewTableView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
    
}
