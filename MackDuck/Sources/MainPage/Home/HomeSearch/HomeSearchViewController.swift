//
//  HomeSearchViewController.swift
//  MackDuck
//
//  Created by sumin on 2021/11/23.
//

import UIKit

class HomeSearchViewController: UIViewController {

    var dataManager: HomeRecentPopularDataManager = HomeRecentPopularDataManager() // 최근검색어, 인기검색어 dataManager
    var deleteDataManager: HomeRecentDeleteDataManager = HomeRecentDeleteDataManager() // 최근검색어 지우는 dataManager
    
    var searchingDataManager: HomeSearchingDataManager = HomeSearchingDataManager() // 검색중 가져오는 dataManager
    var searchResultDataManager: HomeSearchResultDataManager = HomeSearchResultDataManager() // 검색 결과 가져오는 dataManager
    var sendBeerInfoDataManager: SendBeerInfoDataManager = SendBeerInfoDataManager() // 없는 맥주 정보 전송하는 dataManager
    
    @IBOutlet weak var searchBar: UITextField! // 검색창
    
    @IBOutlet weak var recentTitle: UILabel! // 최근 검색어 라벨
    @IBOutlet weak var deleteAllButton: UIButton! // 전체삭제 버튼
    @IBOutlet weak var recentStackView: UIStackView! // 최근 검색어 라벨들 모은 스택뷰
    @IBOutlet var recentSearchLabels: [UILabel]!
    @IBOutlet var recentSearchDates: [UILabel]!
    
    @IBOutlet weak var popularTitle: UILabel! // 인기 검색어 라벨
    @IBOutlet weak var popularTableView: UITableView! // 인기검색어 테이블뷰
    var BestSearchList: [BestSearchModel] = [] // 인기검색어 데이터(모델)들
    var SearchingList: [SearchingModel] = [] // 검색결과(keyword) 데이터(모델)들
    var SearchResultList: [SearchResultModel] = [] // 검색결과(keyword) 데이터(모델)들
    
    @IBOutlet weak var searchingTableView: UITableView! // 검색중인 것 보여줄 테이블뷰
    @IBOutlet weak var searchResultTableView: UITableView! // 검색 결과 보여줄 테이블뷰
    
    @IBOutlet weak var notInfoLabel: UILabel! // 맥주 정보 없다고 안내하는 라벨.
    @IBOutlet weak var sendInfoButton: UIButton! // 맥덕이에게 맥주 이름 서버에 전송하는 버튼.
    
    var searchingKeyword: String = "" // 검색하는 키워드 저장할 변수 선언.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .mainBlack
        
        
        searchBar.delegate = self
        searchBar.addTarget(self, action: #selector(textFieldDidchange(textField:)), for: UIControl.Event.editingChanged)
        
        searchBar.returnKeyType = .search
        searchBarCustom()
        
//        // 검색창 애니메이션
//        UIView.animate(withDuration: 0.3, animations: ({
//            self.searchBar.transform = CGAffineTransform(translationX: 0, y: -94)
//        }))
        
//        popularTableView.estimatedRowHeight = 100 // 테이블뷰 cell self sizing
//        popularTableView.rowHeight = UITableView.automaticDimension
        
        searchResultTableView.isHidden = true
        searchingTableView.isHidden = true
        notInfoLabel.isHidden = true // 검색결과 없다는 라벨 가림.
        
        // 맥덕이에게 전송하는 버튼 디자인.
        sendInfoButton.isHidden = true // 맥덕이에게 전송하는 버튼 가림.
        sendInfoButton.isUserInteractionEnabled = true // 맥덕이에게 전송버튼 - 제한 풀어둠.
        sendInfoButton.borderColor = UIColor.subGray1
        sendInfoButton.backgroundColor = nil
        sendInfoButton.tintColor = UIColor.mainGray
        let text: String = "+ 맥덕이에게 맥주 정보를 추가 요청해보세요!"
        let attributeString = NSMutableAttributedString(string: text)
        let font = UIFont(name: "NotoSansKR-Regular", size: 12)
        attributeString.addAttribute(.font, value: font!, range: (text as NSString).range(of: "\(text)"))
        sendInfoButton.setAttributedTitle(attributeString, for: .normal)
        
        popularTableView.showsHorizontalScrollIndicator = false // 인기 검색어 - 테이블뷰 스크롤바 숨김
        popularTableView.showsVerticalScrollIndicator = false

        searchingTableView.showsHorizontalScrollIndicator = false // 검색중 - 테이블뷰 스크롤바 숨김
        searchingTableView.showsVerticalScrollIndicator = false
        
        searchResultTableView.showsHorizontalScrollIndicator = false // 검색결과 - 테이블뷰 스크롤바 숨김
        searchResultTableView.showsVerticalScrollIndicator = false
    
        popularTableView.delegate = self
        popularTableView.dataSource = self
        searchingTableView.delegate = self
        searchingTableView.dataSource = self
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
        searchingTableView.separatorStyle = .none // 검색중 밑줄 없애기
        searchResultTableView.separatorStyle = .none // 검색결과 밑줄 없애기
        
        popularTableView.register(BestSearchTableViewCell.nib(), forCellReuseIdentifier: BestSearchTableViewCell.identifier) // 테이블뷰(최하단 인기검색어) cell 등록
        searchingTableView.register(SearchingTableViewCell.nib(), forCellReuseIdentifier: SearchingTableViewCell.identifier) // 테이블뷰(검색중) cell 등록
        searchResultTableView.register(SearchResultTableViewCell.nib(), forCellReuseIdentifier: SearchResultTableViewCell.identifier) // 테이블뷰(검색 결과) cell 등록
        
    }
    
    func searchBarCustom(){
        searchBar.addLeftPadding()
        searchBar.tintColor = .mainYellow // 커서 색상 변경.
        searchBar.backgroundColor = .subBlack
        searchBar.attributedPlaceholder = NSAttributedString(string:"입력해주세요.", attributes:[NSAttributedString.Key.foregroundColor: UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1), NSAttributedString.Key.font :UIFont(name: "NotoSansKR-Regular", size: 14)!])
        searchBar.borderWidth = 2.5
        searchBar.cornerRadius = 10
        searchBar.clipsToBounds = true
        searchBar.borderColor = .mainYellow
        
        // https://zeddios.tistory.com/1291
        var configuration = UIButton.Configuration.tinted()
        configuration.image = UIImage(imageLiteralResourceName: "magnifyingGlassYellow")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 30
        configuration.baseBackgroundColor = .subBlack
//        configuration.baseForegroundColor = .mainBlack
        
        let searchButton = UIButton(configuration: configuration, primaryAction: nil)
        searchButton.backgroundColor = .mainBlack
        searchBar.rightView = searchButton
        searchBar.rightViewMode = .always
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = true
        self.dataManager.postHomeRecentPopularInfo(delegate: self) // 최근검색어, 인기검색어 api 호출.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.tabBarController?.tabBar.isHidden = false
    }
    
    // 뷰 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
    }
    
//    @objc func searchFinish(_ sender: UIButton){
//        print("searchFinish() called")
//        infoSendButton.isEnabled = true
//        infoSendButton.layer.cornerRadius = 20
//        infoSendButton.layer.borderColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1).cgColor
//        infoSendButton.backgroundColor = UIColor.clear
//        infoSendButton.layer.borderWidth = 1
//        tableView.isHidden = false
//        searchState = 2
//        tableView.reloadData()
//    }

    // 전체삭제 버튼 클릭 시,
    @IBAction func clickDeleteAllButton(_ sender: UIButton) {
        let userId = UserDefaults.standard.integer(forKey: "userId") // UserDefaults에서 userId값 불러옴.
        self.deleteDataManager.postHomeRecentDeleteInfo(userId: userId, delegate: self) // 최근검색어 지우는 api 호출.
    }
    
    
    @IBAction func clickBackButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // 맥덕이에게 맥주정보 전송버튼 클릭 시,
    @IBAction func clickSendInfoButton(_ sender: UIButton) {
        sendInfoButton.isUserInteractionEnabled = false // 맥덕이에게 전송버튼 - 한번만 누를 수 있게.
        // 맥덕이에게 전송 버튼 클릭시 화이트로 디자인 변경.
        sendInfoButton.borderColor = UIColor.subGray2
        sendInfoButton.backgroundColor = UIColor.subGray2
        sendInfoButton.tintColor = UIColor.mainWhite
        let text: String = "✓  맥덕이에게 전달 되었어요!"
        let attributeString = NSMutableAttributedString(string: text)
        let font = UIFont(name: "NotoSansKR-Bold", size: 13)
        attributeString.addAttribute(.font, value: font!, range: (text as NSString).range(of: "\(text)"))
        sendInfoButton.setAttributedTitle(attributeString, for: .normal)
        
        let userId = UserDefaults.standard.integer(forKey: "userId") // UserDefaults에서 userId값 불러옴.
        let input = SendBeerInfoRequest(keyword: searchingKeyword)
        self.sendBeerInfoDataManager.postBeerInfo(userId: userId, parameters: input, delegate: self) // 맥덕이에게 맥주이름 전송하는 api 호출.
    }
    
}

// MARK: - 최상단 searchBar(textField) 검색 부분
extension HomeSearchViewController: UITextFieldDelegate {
    
    @objc func textFieldDidchange(textField: UITextField){
        if textField.text!.count > 0 { // 검색어 입력 중일 시 -> 기존 화면들 숨기기. & 검색 테이블뷰 띄우기.
            recentTitle.isHidden = true
            deleteAllButton.isHidden = true
            recentStackView.isHidden = true
            popularTitle.isHidden = true
            popularTableView.isHidden = true
            searchingTableView.isHidden = false // 검색중 테이블뷰 띄움.
            searchResultTableView.isHidden = true // 검색결과 테이블뷰 가림.
            notInfoLabel.isHidden = true // 검색결과없다는 라벨 가림.
            print(textField.text!)
            
            // 맥덕이에게 전송하는 버튼 다시 세팅.
            sendInfoButton.isHidden = true // 맥덕이에게 전송하는 버튼 가림.
            sendInfoButton.isUserInteractionEnabled = true // 맥덕이에게 전송버튼 - 제한 풀어둠.
            sendInfoButton.borderColor = UIColor.subGray1
            sendInfoButton.backgroundColor = nil
            sendInfoButton.tintColor = UIColor.mainGray
            let text: String = "+ 맥덕이에게 맥주 정보를 추가 요청해보세요!"
            let attributeString = NSMutableAttributedString(string: text)
            let font = UIFont(name: "NotoSansKR-Regular", size: 12)
            attributeString.addAttribute(.font, value: font!, range: (text as NSString).range(of: "\(text)"))
            sendInfoButton.setAttributedTitle(attributeString, for: .normal)
            
            SearchingList.removeAll() // 검색 중 - 담는 리스트의 모든 element들을 지워줘야 함. (안 지우면 계속 데이터 남아있어서 결과가 쌓임)
            SearchResultList.removeAll() // 검색 결과 - 담는 리스트의 모든 element들을 지워줘야 함. (안 지우면 계속 데이터 남아있어서 결과가 쌓임)
            
            searchingKeyword = textField.text! // 검색하는 내용을 변수에 저장.
            self.searchingDataManager.postHomeSearchingKeyword(keyword: textField.text!, delegate: self) // 검색중 api 호출.
            
        } else { // 검색어 입력 중 아닐 시 -> 숨겼던 기존의 화면들 다시 띄우기. & 검색 테이블뷰 숨기기.
            recentTitle.isHidden = false
            deleteAllButton.isHidden = false
            recentStackView.isHidden = false
            popularTitle.isHidden = false
            popularTableView.isHidden = false
            searchingTableView.isHidden = true // 검색중 테이블뷰 가림.
            searchResultTableView.isHidden = true // 검색결과 테이블뷰 가림.
            
            print("입력 없는상태.")
        }
        
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) { // searchBar.endEditing()시 작동.
//        print("검색중 cell 클릭 - 자동 Return")
//        searchingTableView.isHidden = true // 검색중 테이블뷰 가림.
//        searchResultTableView.isHidden = false // 검색결과 테이블뷰 띄움.
//        self.searchResultDataManager.postHomeRecentKeywordResult(keyword: textField.text!, delegate: self) // 검색 api 호출.
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { // 키보드 Return(앤터) 버튼 클릭시 작동.
        print("검색창 Return 엔터 클릭.")
        searchingKeyword = textField.text! // 검색단어 저장.
        
        searchingTableView.isHidden = true // 검색중 테이블뷰 가림.
        searchResultTableView.isHidden = false // 검색결과 테이블뷰 띄움.
        self.searchResultDataManager.postHomeRecentKeywordResult(keyword: textField.text!, delegate: self) // 검색 api 호출.
        
        searchBar.resignFirstResponder() // Return(앤터) 버튼 클릭시 키보드 내리기
        return true
    }
}


// MARK: - 중상단 최근검색어, 인기검색어 Api
extension HomeSearchViewController {
    
    // jwt(x-access-token)가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에 최근검색어, 인기검색어 값들 보이게 설정.
    func didSuccessRecentPopular(_ result: HomeRecentPopularResponse) {
        print("서버에서 최근검색어, 인기검색어 GET 성공!")
        print("response 내용 : \(result)")
        
        // 가져온 값들을 최근 검색어 Stack에 데이터 넣음.
        var recentKeywordArray: [String] = [] // 최근 검색어 저장할 배열
        var recentDateArray: [String] = [] // 최근 검색어 날짜 저장할 배열
        DispatchQueue.main.async {
            for keyword in result.result.recentKeyword {
                recentKeywordArray.append(keyword.keyword) // 최근 검색어 저장
                recentDateArray.append(keyword.createdAt) // 최근 검색어 날짜 저장
            }
            
            for i in 0..<5 {
                if i < recentKeywordArray.count { // 받아온 것들 중 값이 있는 index까진,
                    self.recentSearchLabels[i].text = recentKeywordArray[i]
                    self.recentSearchDates[i].text = recentDateArray[i]
                }
                else { // 값이 없는 라벨들은 숨김.
                    self.recentSearchLabels[i].isHidden = true
                    self.recentSearchDates[i].isHidden = true
                }
            }
            
            if recentKeywordArray.count == 0 { // 최근 검색어가 0개라면,
                self.recentSearchLabels[0].isHidden = false // 일단 가려진거 다시 풂.
                self.recentSearchDates[0].isHidden = false // 일단 가려진거 다시 풂.
                self.recentSearchLabels[0].text = "최근 검색어가 없습니다."
                self.recentSearchDates[0].text = ""
            }
            
        }
        
        BestSearchList.removeAll() // 인기검색어 리스트 - 담는 리스트의 모든 element들을 지워줘야 함. (안 지우면 계속 데이터 남아있어서 결과가 쌓임)
        // 가져온 값들을 BestSearchList에 데이터 넣음.
        DispatchQueue.main.async {
            for popularSearchData in result.result.popularBeer {
                self.BestSearchList.append(BestSearchModel(beerId: popularSearchData.beerID, beerImageUrl: popularSearchData.beerImgURL, beerName: popularSearchData.nameKr, beerKind: popularSearchData.beerKind, beerAlcohol: popularSearchData.alcohol, beerFeature: popularSearchData.feature, beerReviewCount: popularSearchData.reviewCount))
            }
            self.popularTableView.reloadData() // 테이블뷰 .reloadData()를 해줘야 데이터가 반영됨.
        }
        
    }

    func failedToRequest(message: String, code: Int) { // 오류메시지 & code번호 몇인지
        print("서버 Request 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
        }
    }
    
}


// MARK: - 중상단 최근검색어 Delete Api
extension HomeSearchViewController {
    
    // userId가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에서 최근검색어 삭제하게 설정.
    func didSuccessDeleteRecent(_ result: HomeRecentDeleteResponse) {
        print("서버에 최근검색어 삭제 PATCH 성공!")
        print("response 내용 : \(result)")
        
        // 서버에 지웠으니 -> 앱에서도 최근검색어&날짜 지움(가림).
        DispatchQueue.main.async {
            
            self.recentSearchLabels[0].text = "최근 검색어가 없습니다." // 0번째 라벨엔 최근 검색어가 없다고 표시해줌.
            self.recentSearchDates[0].text = ""
            
            for i in 1..<5 {
                self.recentSearchLabels[i].isHidden = true
                self.recentSearchDates[i].isHidden = true
            }
        }
        
    }

    func failedToDeleteRequest(message: String, code: Int) { // 오류메시지 & code번호 몇인지
        print("서버 Request 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
        }
        else if code == 2016 { // 실패 이유 : "유저 아이디값을 확인해주세요."
            
        }
        else if code == 3022 { // 실패 이유 : "최근검색어가 존재하지 않습니다."
            
        }
    }
    
}

// MARK: - 검색중 Keyword Api
extension HomeSearchViewController {
    // 검색어(keyword)가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에 검색결과 값들 보이게 설정.
    func didSuccessSearching(_ result: HomeSearchingResponse) {
        print("서버에서 검색결과 GET 성공!")
        print("response 내용 : \(result)")
        
        // 가져온 값들을 SearchingList에 데이터 넣음.
        DispatchQueue.main.async {
            for searchKeywordData in result.result {
                self.SearchingList.append(SearchingModel(beerId: searchKeywordData.beerId, beerNameEn: searchKeywordData.nameEn, beerNameKr: searchKeywordData.nameKr))
            }
            self.searchingTableView.reloadData() // 테이블뷰 .reloadData()를 해줘야 데이터가 반영됨.
        }
        
    }

    func failedToRequest2(message: String, code: Int) { // 오류메시지 & code번호 몇인지
        print("서버 Request2 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        self.searchingTableView.reloadData() // 테이블뷰 .reloadData()를 해줘야 데이터가 반영됨.
        
        if code == 2030 { // 실패 이유 : "keyword를 입력해주세요."
            print(message)
        }
        else if code == 3007 { // 실패 이유 : "해당 키워드에 대한 맥주 정보가 없어요...."
            print(message)
        }
    }
    
}

// MARK: - 검색결과 Keyword Api
extension HomeSearchViewController {
    
    // jwt(x-access-token)와 검색어(keyword)가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에 검색결과 값들 보이게 설정.
    func didSuccessSearchResult(_ result: HomeSearchResultResponse) {
        print("서버에서 검색결과 GET 성공!")
        print("response 내용 : \(result)")
        
        SearchResultList.removeAll() // 검색 결과 - 담는 리스트의 모든 element들을 지워줘야 함. (안 지우면 계속 데이터 남아있어서 결과가 쌓임)
        
        // 가져온 값들을 SearchResultList에 데이터 넣음.
        DispatchQueue.main.async {
            for searchKeywordData in result.result {
                self.SearchResultList.append(SearchResultModel(beerId: searchKeywordData.beerId, beerImageUrl: searchKeywordData.beerImgUrl, beerNameEn: searchKeywordData.nameEn, beerNameKr: searchKeywordData.nameKr, beerReviewAverage: searchKeywordData.reviewAverage, beerReviewCount: searchKeywordData.reviewCount))
            }
            self.searchResultTableView.reloadData() // 테이블뷰 .reloadData()를 해줘야 데이터가 반영됨.
        }
        
    }

    func failedToRequest3(message: String, code: Int) { // 맥주에 대한 정보가 없을 때 - 오류메시지 & code번호 몇인지
        print("서버 Request3 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        self.searchResultTableView.reloadData() // 테이블뷰 .reloadData()를 해줘야 데이터가 반영됨.
        
        notInfoLabel.isHidden = false // ex) '포도' 맥주에 대한 정보가 없어요..! 띄움.
        sendInfoButton.isHidden = false // 검색결과없는거 전송하는 버튼 띄움.
        
        let text: String = "'\(searchBar.text!)' 맥주에 대한 정보가 없어요..!" // ex) '포도' 맥주에 대한 정보가 없어요..!
        let attributeString = NSMutableAttributedString(string: text) // 텍스트 일부분 색상, 폰트 변경 - https://icksw.tistory.com/152
        attributeString.addAttribute(.foregroundColor, value: UIColor.subYellow, range: (text as NSString).range(of: "'\(searchBar.text!)'")) // '포도' 부분 색상 변경.
        self.notInfoLabel.attributedText = attributeString // ex) '포도' 맥주에 대한 정보가 없어요..!
        
        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
            print(message)
        }
        else if code == 2030 { // 실패 이유 : "keyword를 입력해주세요."
            print(message)
        }
        else if code == 3020 { // 실패 이유 : "해당 키워드에 대한 맥주 정보가 없어요...."
            print(message)
        }
    }
    
}

// MARK: - 맥덕이에게 맥주이름 전송 Api
extension HomeSearchViewController {
    
    // keyword가 서버에 제대로 보내졌다면
    func didSuccessPostBeerInfo(_ result: SendBeerInfoResponse) {
        print("맥덕이에게 맥주이름 전송 성공!")
        print("response 내용 : \(result)")
        
        // TODO: - 버튼 변경작업 필요.
        
    }

    func failedToPostBeerInfo(message: String, code: Int) { // 오류메시지 & code번호 몇인지
        print("서버 Request 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        if code == 2000 { // 실패 이유 : "JWT 토큰을 입력해주세요."
//            showAlert(title: message, message: "")
        }
        else if code == 2016 { // 실패 이유 : "유저 아이디값을 확인해주세요."
            
        }
        else if code == 2034 { // 실패 이유 : "맥덕이에게 전달할 keyword를 입력해주세요."
            
        }
    }
    
}


// MARK: - 최하단 인기검색어 테이블뷰 부분 & 상단 검색어 입력시 검색결과 테이블뷰 부분
extension HomeSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == popularTableView {
            return BestSearchList.count // 최대 5개임
        }
        if tableView == searchingTableView {
            return SearchingList.count // 검색중 개수만큼
        }
        if tableView == searchResultTableView {
            return SearchResultList.count // 검색 결과 개수만큼
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView == popularTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: BestSearchTableViewCell.identifier, for: indexPath) as! BestSearchTableViewCell
            
            let bestSearchModel: BestSearchModel = BestSearchList[indexPath.row]
            
            let url = URL(string: bestSearchModel.beerImageUrl)
            // DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
            DispatchQueue.global(qos: .background).async { // DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    cell.beerImageView.image = UIImage(data: data!) // 만약 url이 없다면(안 들어온다면) try-catch로 확인해줘야 함.
                    cell.beerImageView.contentMode = .scaleAspectFit
                }
            }
            cell.beerName.text = "\(indexPath.row + 1). " + bestSearchModel.beerName // ex) 1. 호가든
            
            let beerClassAlcohol = "맥주 종류 : " + bestSearchModel.beerKind + " / " + "알콜 도수 : " + bestSearchModel.beerAlcohol // 맥주 종류 & 알콜 도수 text 합침.
            cell.beerClassification.text = beerClassAlcohol

            cell.beerFeature.text = "특징 : " + bestSearchModel.beerFeature
            
            return cell
        }
        
        else if tableView == searchingTableView { // 검색중 테이블뷰 일 때
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchingTableViewCell.identifier, for: indexPath) as! SearchingTableViewCell
            
            let searchingModel: SearchingModel = SearchingList[indexPath.row]
            
            let text: String = "\(searchingModel.beerNameKr)(\(searchingModel.beerNameEn))" // ex) 제주 위트 에일(JEJU Wit ale)
            let attributeString = NSMutableAttributedString(string: text) // 텍스트 일부분 색상, 폰트 변경 - https://icksw.tistory.com/152
            // 문자열에서 원하는 문자의 인덱스 찾는 방법 - t.ly/ci4z
            var textFirstIndex: Int = 0 // 검색중인 키워드가 가장 처음으로 나온 인덱스를 저장할 변수 선언.
            if let textFirstRange = text.range(of: "\(searchingKeyword)", options: .caseInsensitive) { // 검색중인 키워드가 있을 때에만 색상 변경 - 검색중인 키워드가 가장 처음으로 일치하는 문자열의 범위를 알아낼 수 있음. (caseInsensitive:대소문자 구분X)
                textFirstIndex = text.distance(from: text.startIndex, to: textFirstRange.lowerBound) // 거리(인덱스) 구해서 저장.
                
//                attributeString.addAttribute(.foregroundColor, value: UIColor.subYellow, range: (text as NSString).range(of: "\(searchBar.text!)")) // 텍스트 색상(yellow) 변경. - 아래 코드가 아닌, 이 코드로 진행한다면 영어 대소문자 미구분 기능 추가 필요.
                attributeString.addAttribute(.foregroundColor, value: UIColor.subYellow, range: NSRange(location: textFirstIndex, length: searchingKeyword.count)) // 텍스트 색상(yellow) 변경.
                attributeString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: cell.beerName.font.pointSize), range: NSRange(location: textFirstIndex, length: searchingKeyword.count)) // 기존 사이즈 변경 없이 bold처리 : https://stackoverflow.com/questions/39999093/swift-programmatically-make-uilabel-bold-without-changing-its-size
                cell.beerName.attributedText = attributeString // ex) "제주" 위트 에일(JEJU Wit ale)
                cell.selectionStyle = .none // 테이블뷰 cell 선택시 배경색상 없애기 : https://gonslab.tistory.com/41 | https://sweetdev.tistory.com/105
            }
            
            return cell
        }
        
        else { // 검색결과 테이블뷰 일때, (어쩔 수 없이 else로 함. -> xcode에서 예외 return 상황 발생한다고(안그렇지만..) 경고 해서. )
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as! SearchResultTableViewCell
            if tableView == searchResultTableView {
                let searchResultModel: SearchResultModel = SearchResultList[indexPath.row]
                
                let url = URL(string: searchResultModel.beerImageUrl)
                
                // DispatchQueue를 쓰는 이유 -> 이미지가 클 경우 이미지를 다운로드 받기 까지 잠깐의 멈춤이 생길수 있다. (이유 : 싱글 쓰레드로 작동되기때문에)
                DispatchQueue.global(qos: .background).async { // DispatchQueue를 쓰면 멀티 쓰레드로 이미지가 클경우에도 멈춤이 생기지 않는다.
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        cell.beerImage.image = UIImage(data: data!) // 만약 url이 없다면(안 들어온다면) try-catch로 확인해줘야 함.
                        cell.beerImage.contentMode = .scaleAspectFit
                    }
                }
                
                
                cell.beerNameEn.text = searchResultModel.beerNameEn // ex) JEJU Wit ale
                cell.beerNameKr.text = searchResultModel.beerNameKr // ex) 제주 위트 에일
                cell.starScore.text = searchResultModel.beerReviewAverage // ex) 4(리뷰 점수)
                // TODO: - 소수점 score를 정수로 바꾸고 그 점수까지 스타 yellow이미지로 바꾸게 추가해줘야 함.
                let score: Int = Int(floor(Double(searchResultModel.beerReviewAverage)!))
                
                for i in 0..<score {
                    cell.starImages[i].image = UIImage(named: "searchResultStarYellow.png")
                }
                
                cell.reviewCount.text = String(searchResultModel.beerReviewCount) + "개의 리뷰" // ex) 235개의 리뷰
                cell.selectionStyle = .none // 테이블뷰 cell 선택시 배경색상 없애기 : https://gonslab.tistory.com/41 | https://sweetdev.tistory.com/105
                self.popularTableView.reloadData() // 테이블뷰 .reloadData()를 해줘야 데이터가 반영됨.
            }
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == popularTableView {
            print(BestSearchList[indexPath.row].beerName)
            searchBar.text = BestSearchList[indexPath.row].beerName // 인기검색어 - cell 클릭 시 textfield에 추가.
        }
        if tableView == searchingTableView {
            print(SearchingList[indexPath.row].beerNameKr)
            searchBar.text = SearchingList[indexPath.row].beerNameKr // 검색중 - cell 클릭 시 textfield에 추가되고,
//            searchBar.endEditing(true) // 작성 끝내게 하고 -> func textFieldDidEndEditing 으로 -> 검색(return)되게 함.
        }
        if tableView == searchResultTableView {
            // TODO: - 상세 설명 페이지로 연결시켜줘야 함.
            print(SearchResultList[indexPath.row].beerNameKr)
            let beerDetailVC = (self.storyboard?.instantiateViewController(withIdentifier: "BeerDetailVC"))
            self.navigationController?.pushViewController(beerDetailVC!, animated: true)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == popularTableView {
            return 150
        }
        if tableView == searchingTableView {
            return 50
        }
        if tableView == searchResultTableView {
            return 150
        }
        return 0
    }
    
}

