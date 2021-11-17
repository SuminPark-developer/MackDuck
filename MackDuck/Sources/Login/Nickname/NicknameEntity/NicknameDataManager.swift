//
//  NicknameDataManager.swift
//  MackDuck
//
//  Created by sumin on 2021/11/17.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "X-ACCESS-TOKEN": UserDefaults.standard.string(forKey: "jwtToken")!
//]

class NicknameDataManager {
    
    func postNicknameInfo(nickname: String, delegate: LoginHowToCallViewController) {
        let parameters: Parameters = [
                    "nickname": nickname
        ]
        AF.request("\(Constant.BASE_URL)/sign-up/q", method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil)
            .validate()
            .responseDecodable(of: NicknameResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessNickname(response) // LoginHowToCallViewController의 didSuccessNickname메서드 호출.
                        print("닉네임 GET 성공")
                    }
                    else { // 실패했을 때
                        switch response.code {
                        case 2006: delegate.failedToRequest(message: "닉네임을 입력해주세요.", code: 2006)
                        case 2007: delegate.failedToRequest(message: "닉네임길이는 최소2자리에서 최대6자리입니다.", code: 2007)
                        case 3002: delegate.failedToRequest(message: "중복된 닉네임입니다.", code: 3002)
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
