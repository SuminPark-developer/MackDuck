//
//  SendBeerInfoDataManager.swift
//  MackDuck
//
//  Created by sumin on 2022/01/04.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "x-access-token": UserDefaults.standard.string(forKey: "x-access-token")! // UserDefaults에서 jwt값(x-access-token) 불러옴.
//]

class SendBeerInfoDataManager {
    // 맥주 이름 서버에 POST하는 함수.
    func postBeerInfo(userId: Int, parameters: SendBeerInfoRequest, delegate: HomeSearchViewController) {
        let pathVariable: String = String(userId) // pathVariable - https://stackoverflow.com/questions/63041566/alamofire-add-path-variable-to-url
        AF.request("\(Constant.BASE_URL)/users/\(pathVariable)/beer-feedback", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: headers)
            .validate()
            .responseDecodable(of: SendBeerInfoResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessPostBeerInfo(response) // HomeSearchViewController의 didSuccessPostBeerInfo메서드 호출.
                        print("맥덕이에게 맥주이름 전송 성공!")
                    }
                    else { // 실패했을 때
                        switch response.code {
                        case 2000: delegate.failedToPostBeerInfo(message: "JWT 토큰을 입력해주세요.", code: 2000)
                        case 2016: delegate.failedToPostBeerInfo(message: "유저 아이디값을 확인해주세요.", code: 2016)
                        case 2034: delegate.failedToPostBeerInfo(message: "맥덕이에게 전달할 keyword를 입력해주세요.", code: 2034)
                        default: delegate.failedToPostBeerInfo(message: "에러 피드백을 주세요.", code: 4001)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToPostBeerInfo(message: "맥덕이에게 맥주이름 전송 실패 - 서버와의 연결이 원활하지 않습니다.", code: 4444)
                }
            }
    }

}
