//
//  IntroReviewLikeButtonDataManager.swift
//  MackDuck
//
//  Created by sumin on 2022/02/04.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "X-ACCESS-TOKEN": UserDefaults.standard.string(forKey: "jwtToken")!
//]

class IntroReviewLikeButtonDataManager {
    // intro리뷰cell의 좋아요 버튼 - 좋아요데이터 서버에 POST하는 함수.
    func postIntroReviewLike(userId: Int, reviewId: Int, delegate: IntroReviewTableViewCell) {
        let pathVariable1: String = String(userId) // pathVariable - https://stackoverflow.com/questions/63041566/alamofire-add-path-variable-to-url
        let pathVariable2: String = String(reviewId)
        
        AF.request("\(Constant.BASE_URL)/users/\(pathVariable1)/reviews/\(pathVariable2)/like", method: .post, parameters: nil, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseDecodable(of: IntroReviewLikeButtonResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessPostIntroReviewLike(response) // IntroReviewTableViewCell의 didSuccessPostIntroReviewLike메서드 호출.
                        print("intro리뷰cell 좋아요 POST 성공.")
                    }
                    else { // 실패했을 때
                        switch response.code {
                        case 2000: delegate.failedToPostIntroReviewLike(message: "JWT 토큰을 입력해주세요.", code: 2000)
                        case 2016: delegate.failedToPostIntroReviewLike(message: "유저 아이디값을 확인해주세요.", code: 2016)
                        case 3024: delegate.failedToPostIntroReviewLike(message: "좋아요 누를 리뷰가 존재하지 않습니다.", code: 3024)
                        default: delegate.failedToPostIntroReviewLike(message: "에러 피드백을 주세요.", code: 4001)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToPostIntroReviewLike(message: "리뷰cell 좋아요 POST 실패 - 서버와의 연결이 원활하지 않습니다.", code: 4444)
                }
            }
    }

}
