//
//  ReviewDetailDataManager.swift
//  MackDuck
//
//  Created by sumin on 2022/02/08.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "x-access-token": UserDefaults.standard.string(forKey: "x-access-token")! // UserDefaults에서 jwt값(x-access-token) 불러옴.
//]

class ReviewDetailDataManager {
    // 리뷰사진더보기-리뷰보러가기 : 리뷰정보 서버에서 GET하는 함수.
    func getReviewDetail(reviewId: Int, delegate: ReviewDetailViewController) {
        let pathVariable: String = String(reviewId) // pathVariable - https://stackoverflow.com/questions/63041566/alamofire-add-path-variable-to-url
        
        AF.request("\(Constant.BASE_URL)/beers/reviews/\(pathVariable)", method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseDecodable(of: ReviewDetailResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessGetReviewDetail(response) // ReviewDetailViewController의 didSuccessGetReviewDetail메서드 호출.
                        print("리뷰사진더보기-리뷰보러가기 : 리뷰정보 서버에서 GET 성공")
                    }
                    else { // 실패했을 때
                        switch response.code {
                        case 2000: delegate.failedToGetReviewDetail(message: "JWT 토큰을 입력해주세요.", code: 2000)
                        case 3021: delegate.failedToGetReviewDetail(message: "리뷰가 존재하지 않습니다. reviewId를 확인해주세요.", code: 3021)
                        default: delegate.failedToGetReviewDetail(message: "에러 피드백을 주세요.", code: 4001)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToGetReviewDetail(message: "서버와의 연결이 원활하지 않습니다.", code: 4444)
                }
            }
    }

}
