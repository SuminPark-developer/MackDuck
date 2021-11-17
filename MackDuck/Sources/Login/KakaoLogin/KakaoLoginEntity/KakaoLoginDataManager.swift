//
//  KakaoLoginDataManager.swift
//  MackDuck
//
//  Created by sumin on 2021/11/16.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "X-ACCESS-TOKEN": UserDefaults.standard.string(forKey: "jwtToken")!
//]

class KakaoLoginDataManager {
    // accessToken토큰 POST하는 함수.
    func postKakaoLogInInfo(_ parameters: KakaoLoginRequest, delegate: LoginViewController) {
        AF.request("\(Constant.BASE_URL)/users/kakao-login", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: KakaoLoginResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessKakaoLogin(response) // LoginViewController의 didSuccessKakaoLogin메서드 호출.
                        print("Kakao로그인 성공")
                    }
                    else { // 실패했을 때
                        switch response.code {
                        case 2024: delegate.failedToRequest(message: "accessToken을 입력해주세요.", code: 2024)
                        case 2026: delegate.failedToRequest(message: "유효하지 않은 accessToken입니다.", code: 2026)
                        default: delegate.failedToRequest(message: "에러 피드백을 주세요.", code: 4001)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다.", code: 4444)
                }
            }
    }

}
