//
//  HomeRecentPopularDataManager.swift
//  MackDuck
//
//  Created by sumin on 2021/12/01.
//

import Foundation
import Alamofire

let headers: HTTPHeaders = [
    "x-access-token": UserDefaults.standard.string(forKey: "x-access-token")! // UserDefaults에서 jwt값(x-access-token) 불러옴.
]

class HomeRecentPopularDataManager {
    // x-access-token을 보내고 최근검색어와 인기검색어를 GET하는 함수.
    func postHomeRecentPopularInfo(delegate: HomeSearchViewController) {
        AF.request("\(Constant.BASE_URL)/search/recent", method: .get, parameters: nil, headers: headers)
            .validate()
            .responseDecodable(of: HomeRecentPopularResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessRecentPopular(response) // HomeSearchViewController의 didSuccessRecentPopular메서드 호출.
                        print("최근검색어, 인기검색어 조회 성공")
                    }
                    else { // 실패했을 때
                        switch response.code {
                        case 2000: delegate.failedToRequest(message: "JWT 토큰을 입력해주세요.", code: 2000)
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
