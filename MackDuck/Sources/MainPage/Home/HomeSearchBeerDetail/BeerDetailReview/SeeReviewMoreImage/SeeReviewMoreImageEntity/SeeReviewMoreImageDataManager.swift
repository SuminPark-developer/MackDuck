//
//  SeeReviewMoreImageDataManager.swift
//  MackDuck
//
//  Created by sumin on 2022/01/17.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "X-ACCESS-TOKEN": UserDefaults.standard.string(forKey: "jwtToken")!
//]

class SeeReviewMoreImageDataManager {
    // 리뷰 이미지 더보기 - 모든 이미지정보 서버에서 GET하는 함수.
    func getBeerReviewImageInfo(rowNumber: String, beerId: Int, delegate: SeeReviewMoreImageViewController) {
        let parameters: Parameters = [
                    "rowNumber": rowNumber
        ]
        let pathVariable: String = String(beerId) // pathVariable - https://stackoverflow.com/questions/63041566/alamofire-add-path-variable-to-url
        AF.request("\(Constant.BASE_URL)/beers/\(pathVariable)/reviews/images", method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseDecodable(of: SeeReviewMoreImageResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessGetBeerReviewImageInfo(response) // SeeReviewMoreImageViewController의 didSuccessGetBeerReviewImageInfo메서드 호출.
                        print("맥주 리뷰 모든 이미지정보 GET 성공")
                    }
                    else { // 실패했을 때
                        switch response.code {
//                        case 2000: delegate.failedToGetBeerReviewImageInfo(message: "JWT 토큰을 입력해주세요.", code: 2000)
                        case 3017: delegate.failedToGetBeerReviewImageInfo(message: "이미지 리스트가 없습니다.", code: 3010)
                        default: delegate.failedToGetBeerReviewImageInfo(message: "에러 피드백을 주세요.", code: 4001)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToGetBeerReviewImageInfo(message: "서버와의 연결이 원활하지 않습니다.", code: 4444)
                }
            }
    }

}

