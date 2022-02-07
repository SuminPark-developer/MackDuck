//
//  ReviewTripleDotDeleteButtonDataManager.swift
//  MackDuck
//
//  Created by sumin on 2022/02/06.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "x-access-token": UserDefaults.standard.string(forKey: "x-access-token")! // UserDefaults에서 jwt값(x-access-token) 불러옴.
//]

class ReviewTripleDotDeleteButtonDataManager {
    // 리뷰delete 서버에 PATCH하는 함수.
    func postReviewDelete(userId: Int, reviewId: Int, delegate: TripleDotPopupViewController) {
        let pathVariable1: String = String(userId) // pathVariable - https://stackoverflow.com/questions/63041566/alamofire-add-path-variable-to-url
        let pathVariable2: String = String(reviewId)
        
        AF.request("\(Constant.BASE_URL)/users/\(pathVariable1)/reviews/\(pathVariable2)/status", method: .patch, parameters: nil, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseDecodable(of: ReviewTripleDotDeleteButtonResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessDeleteReview(response) // TripleDotPopupViewController의 didSuccessDeleteReview메서드 호출.
                        print("리뷰 delete PATCH 성공")
                    }
                    else { // 실패했을 때
                        switch response.code {
                        case 2000: delegate.failedToDeleteReview(message: "JWT 토큰을 입력해주세요.", code: 2000)
                        case 2016: delegate.failedToDeleteReview(message: "유저 아이디값을 확인해주세요.", code: 2016)
                        case 3018: delegate.failedToDeleteReview(message: "삭제할 리뷰가 존재하지 않습니다.", code: 3018)
                        default: delegate.failedToDeleteReview(message: "에러 피드백을 주세요.", code: 4001)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToDeleteReview(message: "서버와의 연결이 원활하지 않습니다.", code: 4444)
                }
            }
    }

}
