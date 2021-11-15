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

    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .mainBlack
        mainTitle.text = "간편 로그인으로\n모든 맥주 정보를\n즐기세요!"
        subTitle.text = "지금 로그인하고\n100개 이상의 맥주 정보를 얻으세요!"
        mainTitle.textColor = .mainWhite
        subTitle.textColor = .mainWhite
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
                    
                    // TODO: - 화면 이동
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC")
//                    self.present(vc!, animated: true, completion: nil)
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
                    
                    // TODO: - 화면 이동
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC")
//                    self.present(vc!, animated: true, completion: nil)
                    
                }
            }
        }
        
        
        
    }
    

}
