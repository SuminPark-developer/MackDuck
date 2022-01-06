//
//  PrivacySettingViewController.swift
//  MackDuck
//
//  Created by sumin on 2021/11/17.
//

import UIKit

class PrivacySettingViewController: UIViewController {

    var dataManager: PrivacySettingDataManager = PrivacySettingDataManager()
    
    @IBOutlet weak var mainTitle: UILabel! // 개인 정보를 선택하면 끝!
    @IBOutlet weak var signUpButton: UIButton! //가입 완료 버튼
    @IBOutlet weak var navigationBar: UINavigationBar! // 상단 네비게이션 바
    
    @IBOutlet weak var sexBtn1: UIButton! // 성별 버튼(2개)
    @IBOutlet weak var sexBtn2: UIButton!
    
    @IBOutlet weak var ageBtn1: UIButton! // 나이 버튼(6개)
    @IBOutlet weak var ageBtn2: UIButton!
    @IBOutlet weak var ageBtn3: UIButton!
    @IBOutlet weak var ageBtn4: UIButton!
    @IBOutlet weak var ageBtn5: UIButton!
    @IBOutlet weak var ageBtn6: UIButton!
    
    @IBOutlet weak var tasteBtn1: UIButton! // 취향 버튼(8개)
    @IBOutlet weak var tasteBtn2: UIButton!
    @IBOutlet weak var tasteBtn3: UIButton!
    @IBOutlet weak var tasteBtn4: UIButton!
    @IBOutlet weak var tasteBtn5: UIButton!
    @IBOutlet weak var tasteBtn6: UIButton!
    @IBOutlet weak var tasteBtn7: UIButton!
    @IBOutlet weak var tasteBtn8: UIButton!
    
    var sexBtnArray = [UIButton]()
    var ageBtnArray = [UIButton]()
    var tasteBtnArray = [UIButton]()
    
    var kakaoId: Int = 0
    var nickName: String = ""
    var sexBtn: String = ""
    var ageBtn: String = ""
    var beerTasteBtn: Int = 0
    
    var tasteDict = ["라거": 1,"필스너": 2,"둔켈": 3,"에일": 4,"IPA": 5,"밀맥주": 6,"스타우트": 7,"포터": 8]
    
    var chooseSexFlag: Bool = false // 성별 선택 미완료.
    var chooseAgeFlag: Bool = false // 나이 선택 미완료.
    var chooseTasteFlag: Bool = false // 취향 선택 미완료.
    // 모두 true가 되면 (성별, 나이, 취향) 선택 완료이므로 -> 가입완료 버튼 활성화.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .mainBlack
        
        mainTitle.text = "개인 정보를\n선택하면 끝!"
        mainTitle.textColor = .mainWhite
        
        navigationBar.barTintColor = .mainBlack
        navigationBar?.isTranslucent = false // 네비게이션바 반투명 제거
        
        signUpButton.isUserInteractionEnabled = false // 가입완료 버튼 비활성화.
        signUpButton.layer.cornerRadius = 10
        
        sexBtnArray.append(sexBtn1)
        sexBtnArray.append(sexBtn2)
        
        ageBtnArray.append(ageBtn1)
        ageBtnArray.append(ageBtn2)
        ageBtnArray.append(ageBtn3)
        ageBtnArray.append(ageBtn4)
        ageBtnArray.append(ageBtn5)
        ageBtnArray.append(ageBtn6)
        
        tasteBtnArray.append(tasteBtn1)
        tasteBtnArray.append(tasteBtn2)
        tasteBtnArray.append(tasteBtn3)
        tasteBtnArray.append(tasteBtn4)
        tasteBtnArray.append(tasteBtn5)
        tasteBtnArray.append(tasteBtn6)
        tasteBtnArray.append(tasteBtn7)
        tasteBtnArray.append(tasteBtn8)
        
        signUpButton.isUserInteractionEnabled = false
        signUpButton.layer.cornerRadius = 10
        signUpButton.backgroundColor = .mainGray
        
        
    }
    
    
    // 선택 풀릴 때,
    func unselectedButtonCustom(btn: UIButton){
        btn.layer.cornerRadius = 15
        btn.layer.borderColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 136/255).cgColor
        btn.layer.borderWidth = 1
        btn.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
//        btn.setTitleColor(.mainGray, for: .normal)
        btn.titleLabel?.font = UIFont(name: "NotoSansKR-Regular", size: 13)

    }
    
    // MARK: - 성별
    @IBAction func selectedSexOptionBtnAction(_ sender: UIButton){
        for Btn in sexBtnArray {
            if Btn == sender {
                Btn.isSelected = true
                Btn.backgroundColor = UIColor(red: 252/255, green: 214/255, blue: 2/255, alpha: 1)
                Btn.titleLabel!.font = UIFont(name: "NotoSansKR-Bold", size: 13)
                print(Btn.titleLabel!.text!)
                sexBtn = Btn.titleLabel!.text!
                chooseSexFlag = true // 성별 선택 완료.
            } else {
                Btn.isSelected = false
                unselectedButtonCustom(btn: Btn)
            }
        }
        // 성별, 나이, 취향 다 골랐을 땐 가입 완료 버튼 활성화.
        if chooseSexFlag == true && chooseAgeFlag == true && chooseTasteFlag == true {
            signUpButton.isUserInteractionEnabled = true
            signUpButton.backgroundColor = .mainYellow
        }
    }
    
    // MARK: - 나이
    @IBAction func selectedAgeOptionBtnAction(_ sender: UIButton){
        for Btn in ageBtnArray {
            if Btn == sender {
                Btn.isSelected = true
                Btn.backgroundColor = UIColor(red: 252/255, green: 214/255, blue: 2/255, alpha: 1)
                Btn.titleLabel!.font = UIFont(name: "NotoSansKR-Bold", size: 13)
                print(Btn.titleLabel!.text!)
                ageBtn = Btn.titleLabel!.text!
                chooseAgeFlag = true // 나이 선택 완료.
            } else {
                Btn.isSelected = false
                unselectedButtonCustom(btn: Btn)
            }
        }
        // 성별, 나이, 취향 다 골랐을 땐 가입 완료 버튼 활성화.
        if chooseSexFlag == true && chooseAgeFlag == true && chooseTasteFlag == true {
            signUpButton.isUserInteractionEnabled = true
            signUpButton.backgroundColor = .mainYellow
        }
    }
    
    // MARK: - 취향
    @IBAction func selectedTasteOptionBtnAction(_ sender: UIButton){
        for Btn in tasteBtnArray {
            if Btn == sender {
                Btn.isSelected = true
                Btn.backgroundColor = UIColor(red: 252/255, green: 214/255, blue: 2/255, alpha: 1)
                Btn.titleLabel!.font = UIFont(name: "NotoSansKR-Bold", size: 13)
                print(tasteDict["\(Btn.titleLabel!.text ?? "")"]!)
                beerTasteBtn = tasteDict["\(Btn.titleLabel!.text ?? "")"]!
                chooseTasteFlag = true // 취향 선택 완료.
            } else {
                Btn.isSelected = false
                unselectedButtonCustom(btn: Btn)
            }
        }
        // 성별, 나이, 취향 다 골랐을 땐 가입 완료 버튼 활성화.
        if chooseSexFlag == true && chooseAgeFlag == true && chooseTasteFlag == true {
            signUpButton.isUserInteractionEnabled = true
            signUpButton.backgroundColor = .mainYellow
        }
    }

    // 가입 완료 버튼 클릭시,
    @IBAction func didTabSignUpButton(_ sender: UIButton) {
        print("######## 가입완료 버튼 클릭! #########")
        print("kakaoId: \(kakaoId)")
        print("nickName: \(nickName)")
        print("sexBtn: \(sexBtn)")
        print("ageBtn: \(ageBtn)")
        print("beerTasteBtn: \(beerTasteBtn)")
        
        let input = PrivacySettingRequest(kakaoId: kakaoId, nickname: nickName, gender: sexBtn, age: ageBtn, beerKindId: beerTasteBtn)
        self.dataManager.postPrivacySettingInfo(input, delegate: self)
        
    }
    
    // 좌측 상단 뒤로가기 버튼 클릭시,
    @IBAction func didTabBackButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension PrivacySettingViewController {
    // 회원 정보(카카오 아이디, 닉네임, 성별, 나이, 취향)가 서버에 제대로 보내졌다면 -> 다음페이지로 넘어가게 설정.
    func didSuccessPrivacySetting(_ result: PrivacySettingResponse) {
        print("서버에 POST 성공!")
        print("response 내용 : \(result)")
        
        if result.isSuccess == true { // 회원정보 설정 성공시, 홈(메인) 페이지로 이동.
            
            UserDefaults.standard.set(result.result?.userId, forKey: "userId") // UserDefaults에 userId값 저장.
            
            let goHome = UIStoryboard(name: "MainPageStoryboard", bundle: nil)
            let goHomeVC = goHome.instantiateViewController(withIdentifier: "MainPageTabBarController")
            goHomeVC.modalPresentationStyle = .fullScreen
            self.present(goHomeVC, animated: true, completion: nil)
        }
        
    }


    func failedToRequest(message: String, code: Int) { // 오류메시지 & code번호 몇인지
        print("서버 Request 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        if code == 2006 { // 실패 이유 : "닉네임을 입력해주세요."
            showAlert(title: message, message: "")
        }
        else if code == 2026 { // 실패 이유 : "kakaoId를 입력해주세요."
            showAlert(title: message, message: "")
        }
        else if code == 2027 { // 실패 이유 : "성별을 선택해주세요."
            showAlert(title: message, message: "")
        }
        else if code == 2028 { // 실패 이유 : "나이를 선택해주세요."
            showAlert(title: message, message: "")
        }
        else if code == 2029 { // 실패 이유 : "취향을 입력해주세요."
            showAlert(title: message, message: "")
        }
        else if code == 3027 { // 실패 이유 : "이미 회원입니다."
            showAlert(title: message, message: "")
        }
        
        signUpButton.isUserInteractionEnabled = true // 가입 완료 버튼 비활성화.
        signUpButton.backgroundColor = .mainYellow
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    
}
