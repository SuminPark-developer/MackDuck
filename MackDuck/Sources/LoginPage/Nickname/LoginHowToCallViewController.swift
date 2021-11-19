//
//  LoginHowToCallViewController.swift
//  MackDuck
//
//  Created by sumin on 2021/11/16.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class LoginHowToCallViewController: UIViewController {

    var dataManager: NicknameDataManager = NicknameDataManager()
    
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var nicknameTF: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    var nicknameValidateCheck: Bool = false
    
    var kakaoId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .mainBlack
        mainTitle.text = "어떻게\n불러드릴까요?"
        mainTitle.textColor = .mainWhite
        
        // TF placeholder 색상 변경 -  https://jiyeonlab.tistory.com/14
        nicknameTF.attributedPlaceholder = NSAttributedString(string: "공백없이 한글 6자 이하로 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.mainGray])
        
        nicknameTF.textColor = .white
        nicknameTF.tintColor = .mainYellow
        nicknameTF.layer.borderWidth = 1
        nicknameTF.layer.cornerRadius = 10
        nicknameTF.layer.masksToBounds = true // textField 모서리 둥글게 : https://stackoverflow.com/questions/40316231/textfield-corner-radius-not-sharp-corners
//        nicknameTF.layer.borderColor = UIColor.mainGray.cgColor
        
        
        self.nicknameTF.addTarget(self, action: #selector(self.nicknameFieldDidChange(_:)), for: .editingChanged) // 닉네임 텍스트필드 내용 입력 시 값 변경 감지
        
        nicknameTF.addLeftPadding() // 텍스트필드 좌측 패딩 - https://developer-fury.tistory.com/46
        nextButton.isUserInteractionEnabled = false // 다음 버튼 비활성화.
        nextButton.layer.cornerRadius = 10
        
        print(kakaoId)
    }
    

    // TextField 키보드 제어 -  https://wi0214.tistory.com/5
    override func viewWillAppear(_ animated: Bool) {
        self.nicknameTF.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nicknameTF.resignFirstResponder()
    }
    
    // 닉네임 입력시 글자수 2자이상인지 확인.
    @objc func nicknameFieldDidChange(_ sender: Any?){
        let nicknameCount = nicknameTF?.text!.count
        
        if nicknameCount! >= 2 { // 닉네임 2자 이상 입력 시,
            nextButton.backgroundColor = .mainYellow
            nextButton.isUserInteractionEnabled = true
        }
        else { // 닉네임 0자 or 1자일 땐,
            nextButton.backgroundColor = .mainGray
            nextButton.isUserInteractionEnabled = false
        }
        
    }
    
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        
        if validateNickname(text: nicknameTF.text!) { // 닉네임이 공백없이 한글이라면,
            if nicknameTF.text!.count >= 2 && nicknameTF.text!.count <= 6 { // 닉네임이 2글자 이상 && 6글자 이하라면,
                nicknameValidateCheck = true
            }
            else { // 닉네임이 2글자 미만 || 6글자 초과라면,
                nicknameValidateCheck = false
            }
        }
        else { // 닉네임이 조건(공백이 있거나, 한글아닌게 섞이거나)에 안맞는 상황이라면 Toast.
            nicknameValidateCheck = false
        }
        
        
        print(nicknameValidateCheck)
        if nicknameValidateCheck == true {
            print("server에 포스트.")
//            let input = KakaoLoginRequest(accessToken: oauthToken!.accessToken)
//            self.dataManager.postKakaoLogInInfo(input, delegate: self)
            self.dataManager.postNicknameInfo(nickname: nicknameTF.text!, delegate: self)
        }
        else if nicknameValidateCheck == false {
            showAlert(title: "공백없이 한글 6자 이하로 입력해주세요.", message: "")
            nextButton.backgroundColor = .mainGray
            nextButton.isUserInteractionEnabled = false
        }
        
    }
    
    // 닉네임 유효한지 확인하는 메서드.
    func validateInfo() -> Bool {
        if nicknameValidateCheck == true {
            return true
        } else { return false }
    }
    
}

extension LoginHowToCallViewController {
    
    // 정규식 참고 - https://eeyatho.tistory.com/31
    func validateNickname(text: String) -> Bool {
        let arr = Array(text) // String -> Array
        // 정규식 - 한글만 허용.(공백 허용X)
        let pattern = "^[가-힣]$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            var index = 0
            while index < arr.count { // string 내 각 문자 하나하나 마다 정규식 체크 후 충족하지 못한것은 제거.
                let results = regex.matches(in: String(arr[index]), options: [], range: NSRange(location: 0, length: 1))
                if results.count == 0 {
                    return false
                } else {
                    index += 1
                }
            }
        }
        return true
    }
    
    // nickname이 서버에 제대로 보내졌다면 -> 다음페이지로 넘어가게 설정.
    func didSuccessNickname(_ result: NicknameResponse) {
        print("서버에 POST 성공!")
        print("response 내용 : \(result)")
        
        // 개인정보 설정 페이지로 이동.
        if result.isSuccess == true { // 닉네임 설정 성공시,
            
            let goPrivacySetting = UIStoryboard(name: "LoginStoryboard", bundle: nil)
            let privacySettingVC = goPrivacySetting.instantiateViewController(withIdentifier: "PrivacySettingVC") as! PrivacySettingViewController
            privacySettingVC.kakaoId = kakaoId // PrivacySettingViewController로 kakaoId값 전달.
            privacySettingVC.nickName = nicknameTF.text!
            privacySettingVC.modalPresentationStyle = .overFullScreen
            self.present(privacySettingVC, animated: true, completion: nil)
        }
        
    }


    func failedToRequest(message: String, code: Int) { // 오류메시지 & code번호 몇인지
        print("서버 Request 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        if code == 2006 { // 실패 이유 : "닉네임을 입력해주세요."
            showAlert(title: message, message: "")
        }
        else if code == 2007 { // 실패 이유 : "닉네임길이는 최소2자리에서 최대6자리입니다."
            showAlert(title: message, message: "")
        }
        else if code == 3002 { // 실패 이유 : "중복된 닉네임입니다."
            showAlert(title: message, message: "")
        }
        
        nextButton.backgroundColor = .mainGray // 다음 버튼 비활성화
        nextButton.isUserInteractionEnabled = false
    }
    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    
}
