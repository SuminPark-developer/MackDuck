//
//  AllReviewDataManager.swift
//  MackDuck
//
//  Created by sumin on 2022/01/28.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "X-ACCESS-TOKEN": UserDefaults.standard.string(forKey: "jwtToken")!
//]

class AllReviewDataManager {
    // 리뷰전체보기 - 모든 리뷰데이터 서버에서 GET하는 함수.
    func getAllReview(rowNumber: String, beerId: Int, delegate: AllReviewViewController) {
        let parameters: Parameters = [
                    "rowNumber": rowNumber
        ]
        let pathVariable: String = String(beerId) // pathVariable - https://stackoverflow.com/questions/63041566/alamofire-add-path-variable-to-url
        AF.request("\(Constant.BASE_URL)/beers/\(pathVariable)/reviews/scroll", method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseDecodable(of: AllReviewResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessGetAllReview(response) // AllReviewViewController의 didSuccessGetAllReview메서드 호출.
                        print("모든 리뷰 정보 GET 성공")
                    }
                    else { // 실패했을 때
                        switch response.code {
//                        case 2000: delegate.failedToGetAllReview(message: "JWT 토큰을 입력해주세요.", code: 2000)
                        case 3010: delegate.failedToGetAllReview(message: "해당 상품에 관한 리뷰가 없습니다.", code: 3010)
                        default: delegate.failedToGetAllReview(message: "에러 피드백을 주세요.", code: 4001)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToGetAllReview(message: "모든 리뷰 GET - 서버와의 연결이 원활하지 않습니다.", code: 4444)
                }
            }
    }

}
