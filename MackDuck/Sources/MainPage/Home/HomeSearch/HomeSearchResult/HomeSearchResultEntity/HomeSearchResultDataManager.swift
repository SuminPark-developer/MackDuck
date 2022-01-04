//
//  HomeSearchResultDataManager.swift
//  MackDuck
//
//  Created by sumin on 2021/12/15.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "x-access-token": UserDefaults.standard.string(forKey: "x-access-token")! // UserDefaults에서 jwt값(x-access-token) 불러옴.
//]

class HomeSearchResultDataManager {
    // x-access-token과 keyword를 보내고 검색결과를 GET하는 함수.
    func postHomeRecentKeywordResult(keyword: String, delegate: HomeSearchViewController) {
        let parameters: Parameters = [
                    "keyword": keyword
        ]
        AF.request("\(Constant.BASE_URL)/search/beers/q", method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseDecodable(of: HomeSearchResultResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessSearchResult(response) // HomeSearchViewController의 didSuccessSearchResult메서드 호출.
                        print("검색결과 GET 성공")
                    }
                    else { // 실패했을 때
                        switch response.code {
                        case 2000: delegate.failedToRequest2(message: "JWT 토큰을 입력해주세요.", code: 2000)
                        case 2030: delegate.failedToRequest2(message: "keyword를 입력해주세요.", code: 2030)
                        case 3020: delegate.failedToRequest2(message: "해당 키워드에 대한 맥주 정보가 없어요....", code: 3020)
                        default: delegate.failedToRequest2(message: "에러 피드백을 주세요.", code: 4001)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToRequest3(message: "맥덕이에게 전달하기 띄워야 함. - 서버와의 연결이 원활하지 않습니다.", code: 4444)
                }
            }
    }
    
}
