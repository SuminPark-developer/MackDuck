//
//  LoginViewController.swift
//  MackDuck
//
//  Created by sumin on 2021/11/15.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController {
    
    var dataManager: KakaoLoginDataManager = KakaoLoginDataManager()

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .mainBlack
        mainTitle.text = "간편 로그인으로\n모든 맥주 정보를\n즐기세요!"
        subTitle.text = "지금 로그인하고\n100개 이상의 맥주 정보를 얻으세요!"
        mainTitle.textColor = .mainWhite
        subTitle.textColor = .mainGray
        
        kakaoLoginButton.backgroundColor = .mainYellow
        kakaoLoginButton.layer.cornerRadius = 10
        appleLoginButton.layer.cornerRadius = 10
    }
    

    
    // 카카오 로그인 버튼 클릭 시,
    @IBAction func didTapKakaoLoginButton(_ sender: UIButton) {
        
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) { // 카카오톡 설치 O -> 카카오톡 실행
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() - 카카오톡 앱 success.")

                    //do something
                    _ = oauthToken
                    
                    print(oauthToken!)
//                    print(oauthToken?.accessToken)
                    
                    let input = KakaoLoginRequest(accessToken: oauthToken!.accessToken)
                    self.dataManager.postKakaoLogInInfo(input, delegate: self)
                    
                }
            }
        }
        else {  // 카카오톡 설치 X -> 카톡 이메일, 비번 입력하는 창 실행
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                    
                }
                else {
                    print("loginWithKakaoAccount() - 카톡 이메일, 비번 success.")
                    
                    //do something
                    _ = oauthToken
                    
                    print(oauthToken!)
//                    print(oauthToken?.accessToken)
                    
                    let input = KakaoLoginRequest(accessToken: oauthToken!.accessToken)
                    self.dataManager.postKakaoLogInInfo(input, delegate: self)
                    
                }
            }
        }
        
        
        
    }
    

}


extension LoginViewController {
    // accessToken토큰이 서버에 제대로 보내졌다면 -> 다음페이지로 넘어가게 설정.
    func didSuccessKakaoLogin(_ result: KakaoLoginResponse) {
        print("서버에 POST 성공!")
        print("response 내용 : \(result)")
        
        // UserDefaults에 jwt값(x-access-token) 저장.
        UserDefaults.standard.set(result.result?.jwt, forKey: "x-access-token")
        
//        print("jwt 값 : \(result.result!.jwt)")
//        print("userId 값 : \(result.result!.userId)")
//        print("nickname 값 : \(result.result!.nickname)")
//        print("kakaoId 값 : \(result.result!.kakaoId)")
        
        
        if result.result!.kakaoId != nil { // kakaoId값이 있으면 -> 신규 가입.
            // 닉네임 설정 페이지로 이동.
            let goHowToCall = UIStoryboard(name: "LoginStoryboard", bundle: nil)
            let howToCallVC = goHowToCall.instantiateViewController(withIdentifier: "LoginHowToCallVC") as! LoginHowToCallViewController
            howToCallVC.kakaoId = (result.result?.kakaoId)! // // PrivacySettingViewController로 kakaoId값 전달하기 위해.
            howToCallVC.modalPresentationStyle = .overFullScreen
            self.present(howToCallVC, animated: true, completion: nil)
        }
        
        else { // kakaoId값이 없으면 -> 재로그인.
            // Home - Home 페이지로 이동.
            let goHome = UIStoryboard(name: "MainPageStoryboard", bundle: nil)
            let goHomeVC = goHome.instantiateViewController(withIdentifier: "MainPageTabBarController")
            goHomeVC.modalPresentationStyle = .overFullScreen
            self.present(goHomeVC, animated: true, completion: nil)
        }
        
        
        
        
        // jwt 토큰값 UserDefaults에 저장.
//        UserDefaults.standard.setValue(jwt, forKey: "jwtToken")
        
        
        
    }


    func failedToRequest(message: String, code: Int) { // 오류메시지 & code번호 몇인지
        print("서버 Request 실패...")
        print("실패 이유 : \(message)")
        print("오류 코드 : \(code)")
        
        
        if code == 2024 { // 실패 이유 : "accessToken을 입력해주세요."
            self.showToast(message: message)
        }
        else if code == 2026 { // 실패 이유 : "유효하지 않은 accessToken입니다."
            self.showToast(message: message)
        }
    }
    
    // toast 알림 만들기 - https://royhelen.tistory.com/46
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 15.0)) {
        let toastLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height/2, width: self.view.frame.size.width, height: 50))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 3;
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
