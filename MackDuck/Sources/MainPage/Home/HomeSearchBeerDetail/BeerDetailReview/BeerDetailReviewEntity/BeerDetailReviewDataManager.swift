//
//  BeerDetailReviewDataManager.swift
//  MackDuck
//
//  Created by sumin on 2022/01/13.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "X-ACCESS-TOKEN": UserDefaults.standard.string(forKey: "jwtToken")!
//]

class BeerDetailReviewDataManager {
    // 맥주상세보기 - 리뷰탭(6개) 정보 서버에서 GET하는 함수.
    func getBeerReviewInfo(rowNumber: String, beerId: Int, delegate: BeerDetailReviewViewController) {
        let parameters: Parameters = [
                    "rowNumber": rowNumber
        ]
        let pathVariable: String = String(beerId) // pathVariable - https://stackoverflow.com/questions/63041566/alamofire-add-path-variable-to-url
        AF.request("\(Constant.BASE_URL)/beers/\(pathVariable)/reviews", method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseDecodable(of: BeerDetailReviewResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessGetBeerReviewInfo(response) // BeerDetailReviewViewController의 didSuccessGetBeerReviewInfo메서드 호출.
                        print("맥주 리뷰 정보(6개) GET 성공")
                    }
                    else { // 실패했을 때
                        switch response.code {
                        case 2000: delegate.failedToGetBeerReviewInfo(message: "JWT 토큰을 입력해주세요.", code: 2000)
                        case 3010: delegate.failedToGetBeerReviewInfo(message: "해당 상품에 관한 리뷰가 없습니다.", code: 3010)
                        default: delegate.failedToGetBeerReviewInfo(message: "에러 피드백을 주세요.", code: 4001)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToGetBeerReviewInfo(message: "서버와의 연결이 원활하지 않습니다.", code: 4444)
                }
            }
    }

}

