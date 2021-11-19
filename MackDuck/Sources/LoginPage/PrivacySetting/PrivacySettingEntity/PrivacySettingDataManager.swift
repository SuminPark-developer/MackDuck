//
//  PrivacySettingDataManager.swift
//  MackDuck
//
//  Created by sumin on 2021/11/17.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "X-ACCESS-TOKEN": UserDefaults.standard.string(forKey: "jwtToken")!
//]

class PrivacySettingDataManager {
    // 회원 정보(카카오 아이디, 닉네임, 성별, 나이, 취향) POST하는 함수.
    func postPrivacySettingInfo(_ parameters: PrivacySettingRequest, delegate: PrivacySettingViewController) {
        AF.request("\(Constant.BASE_URL)/sign-up", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: nil)
            .validate()
            .responseDecodable(of: PrivacySettingResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessPrivacySetting(response) // PrivacySettingController의 didSuccessPrivacySetting메서드 호출.
                        print("회원가입(개인정보 설정) 성공.")
                    }
                    else { // 실패했을 때
                        switch response.code {
                        case 2006: delegate.failedToRequest(message: "닉네임을 입력해주세요.", code: 2006)
                        case 2026: delegate.failedToRequest(message: "kakaoId를 입력해주세요.", code: 2026)
                        case 2027: delegate.failedToRequest(message: "성별을 선택해주세요.", code: 2027)
                        case 2028: delegate.failedToRequest(message: "나이를 선택해주세요.", code: 2028)
                        case 2029: delegate.failedToRequest(message: "취향을 입력해주세요.", code: 2029)
                        case 3027: delegate.failedToRequest(message: "이미 회원입니다.", code: 3027)
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
