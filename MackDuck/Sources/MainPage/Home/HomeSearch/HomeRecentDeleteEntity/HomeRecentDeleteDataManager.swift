//
//  HomeRecentDeleteDataManager.swift
//  MackDuck
//
//  Created by sumin on 2021/12/02.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "x-access-token": UserDefaults.standard.string(forKey: "x-access-token")! // UserDefaults에서 jwt값(x-access-token) 불러옴.
//]

class HomeRecentDeleteDataManager {
    // 최근검색어delete 서버에 PATCH하는 함수.
    func postHomeRecentDeleteInfo(userId: Int, delegate: HomeSearchViewController) {
        let pathVariable: String = String(userId) // pathVariable - https://stackoverflow.com/questions/63041566/alamofire-add-path-variable-to-url
        
        AF.request("\(Constant.BASE_URL)/users/\(pathVariable)/recent/status", method: .patch, parameters: nil, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseDecodable(of: HomeRecentDeleteResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessDeleteRecent(response) // HomeSearchViewController의 didSuccessDeleteRecent메서드 호출.
                        print("최근검색어 delete PATCH 성공")
                    }
                    else { // 실패했을 때
                        switch response.code {
                        case 2000: delegate.failedToDeleteRequest(message: "JWT 토큰을 입력해주세요.", code: 2000)
                        case 2016: delegate.failedToDeleteRequest(message: "유저 아이디값을 확인해주세요.", code: 2016)
                        case 3022: delegate.failedToDeleteRequest(message: "최근검색어가 존재하지 않습니다.", code: 3022)
                        default: delegate.failedToDeleteRequest(message: "에러 피드백을 주세요.", code: 4001)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다.", code: 4444)
                }
            }
    }

}
