//
//  AllReviewReportButtonDataManager.swift
//  MackDuck
//
//  Created by sumin on 2022/02/04.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "x-access-token": UserDefaults.standard.string(forKey: "x-access-token")! // UserDefaults에서 jwt값(x-access-token) 불러옴.
//]

class AllReviewReportButtonDataManager {
    // 전체 리뷰 신고 - 서버에 리뷰 신고 POST하는 함수.
    func postAllReviewReport(userId: Int, reviewId: Int, parameters: AllReviewReportButtonRequest, delegate: AllReviewReportPopupViewController) {
        let pathVariable1: String = String(userId) // pathVariable - https://stackoverflow.com/questions/63041566/alamofire-add-path-variable-to-url
        let pathVariable2: String = String(reviewId)
        AF.request("\(Constant.BASE_URL)/users/\(pathVariable1)/reviews/\(pathVariable2)/report", method: .post, parameters: parameters, encoder: JSONParameterEncoder(), headers: headers)
            .validate()
            .responseDecodable(of: AllReviewReportButtonResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessPostAllReviewReport(response) // AllReviewTableViewCell의 didSuccessPostAllReviewReport메서드 호출.
                        print("전체 리뷰 cell - 신고 완료.")
                    }
                    else { // 실패했을 때
                        switch response.code {
                        case 2000: delegate.failedToPostAllReviewReport(message: "JWT 토큰을 입력해주세요.", code: 2000)
                        case 2016: delegate.failedToPostAllReviewReport(message: "유저 아이디값을 확인해주세요.", code: 2016)
                        case 2033: delegate.failedToPostAllReviewReport(message: "reportIndex를 입력해주세요.", code: 2033)
                        case 3023: delegate.failedToPostAllReviewReport(message: "신고할 리뷰가 존재하지 않습니다.", code: 3023)
                        default: delegate.failedToPostAllReviewReport(message: "에러 피드백을 주세요.", code: 4001)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToPostAllReviewReport(message: "전체리뷰cell 신고 실패 - 서버와의 연결이 원활하지 않습니다.", code: 4444)
                }
            }
    }

}
