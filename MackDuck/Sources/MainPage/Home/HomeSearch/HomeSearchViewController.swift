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
    
    @IBOutlet weak var searchBar: UITextField! // 검색창
    
    @IBOutlet var recentSearchLabels: [UILabel]!
    @IBOutlet var recentSearchDates: [UILabel]!
    @IBOutlet weak var deleteAllButton: UIButton! // 전체삭제 버튼
    
    @IBOutlet weak var popularTableView: UITableView! // 인기검색어 테이블뷰
    var BestSearchModels = [BestSearchModel]() // 인기검색어 데이터(모델)들
    
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
        
//        popularTableView.estimatedRowHeight = UITableView.automaticDimension // 테이블뷰 cell self sizing
//        popularTableView.rowHeight = UITableView.automaticDimension
        
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
    
}

// MARK: - 최상단 searchBar(textField) 검색 부분
extension HomeSearchViewController: UITextFieldDelegate {
    
    @objc func textFieldDidchange(textField: UITextField){
        if textField.text!.count > 0 {
            print(textField.text)
        } else {
            print("입력 없는상태.")
        }
//        infoSendButton.isEnabled = true
//        infoSendButton.layer.cornerRadius = 20
//        infoSendButton.layer.borderColor = UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1).cgColor
//        infoSendButton.layer.borderWidth = 1
//        infoSendButton.backgroundColor = UIColor.clear
//        tableView.isHidden = false
//        if textField.text?.count == 0 {
//            print("검색 중이 아닙니다")
//            searchState = 0
//            tableView.reloadData()
//        }else{
//            print("검색 중")
//            searchState = 1
//            tableView.reloadData()
//        }
    }
    
    // 키보드 Return(앤터) 처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return 엔터 클릭")
//        searchState = 2
//        tableView.reloadData()
//        tableView.isHidden = true
//
//        noinfoLabel.text = "'\(textField.text!)' 맥주에 대한 정보가 없어요..!"
//        let attributedString = NSMutableAttributedString(string: noinfoLabel.text!)
//
//        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 252/255, green: 214/255, blue: 2/255, alpha: 1), range: (noinfoLabel.text! as NSString).range(of:"'\(textField.text!)'"))
//
//        noinfoLabel.attributedText = attributedString
//
//
//        noinfoLabel.isHidden = false
//        infoSendButton.isHidden = false
        return true
    }
}


// MARK: - 중상단 최근검색어, 인기검색어 Api
extension HomeSearchViewController {
    
    // jwt(x-access-token)가 서버에 제대로 보내졌다면 -> 화면(HomeStoryboard)에 최근검색어, 인기검색어 값들 보이게 설정.
    func didSuccessRecentPopular(_ result: HomeRecentPopularResponse) {
        print("서버에서 최근검색어, 인기검색어 GET 성공!")
        print("response 내용 : \(result)")
        
//        if result.isSuccess == true { // GET 성공시, 최근검색어, 인기검색어 값들 보이게 설정.
//            if result.result.recentKeyword.isEmpty == true { // 최근검색어가 0개라면,
//                print("최근검색어 없음!")
//            }
//            else { // 최근검색어 1개 이상
//                DispatchQueue.main.async {
//                    for keyword in result.result.recentKeyword {
//                        <#code#>
//                    }
//                }
//            }
//        }
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
                else { // 값이 없을 땐 숨김.
                    self.recentSearchLabels[i].isHidden = true
                    self.recentSearchDates[i].isHidden = true
                }
            }
        }
        
        // TODO: - 여기부분에서, 가져온 값들을 BestSearchModels에 데이터 넣어야 함.
        
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
            for i in 0..<5 {
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


// MARK: - 최하단 인기검색어 테이블뷰 부분
extension HomeSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BestSearchModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BestSearchTableViewCell.identifier, for: indexPath) as? BestSearchTableViewCell else {
            return UITableViewCell()
        }
        
//        cell.configure(with: BestSearchModels)
        // TODO: - 바로 윗부분 cell.configure함수부터 만들면 됨.
        
//        let myData: MyData = myList[indexPath.row]
//        cell.uiName.text = myData.name
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(BestSearchModels[indexPath.row])
    }
    
}
