//
//  IntroBeerDetailDataManager.swift
//  MackDuck
//
//  Created by sumin on 2022/01/06.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "x-access-token": UserDefaults.standard.string(forKey: "x-access-token")! // UserDefaults에서 jwt값(x-access-token) 불러옴.
//]

class IntroBeerDetailDataManager {
    // 맥주디테일정보 서버에서 GET하는 함수.
    func getBeerDetailInfo(beerId: Int, delegate: BeerDetailViewControllerExample) {
        let pathVariable: String = String(beerId) // pathVariable - https://stackoverflow.com/questions/63041566/alamofire-add-path-variable-to-url
        
        AF.request("\(Constant.BASE_URL)/beers/\(pathVariable)", method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: headers)
            .validate()
            .responseDecodable(of: IntroBeerDetailResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessGetBeerInfo(response) // BeerDetailViewController의 didSuccessGetBeerInfo메서드 호출.
                        print("맥주디테일정보 GET 성공.")
                    }
                    else { // 실패했을 때
                        switch response.code {
                        case 2000: delegate.failedToGetBeerInfo(message: "JWT 토큰을 입력해주세요.", code: 2000)
                        case 3011: delegate.failedToGetBeerInfo(message: "상품에 관한 상세화면이 없어요", code: 3011)
                        default: delegate.failedToGetBeerInfo(message: "에러 피드백을 주세요.", code: 4001)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToGetBeerInfo(message: "서버와의 연결이 원활하지 않습니다.", code: 4444)
                }
            }
    }

}
