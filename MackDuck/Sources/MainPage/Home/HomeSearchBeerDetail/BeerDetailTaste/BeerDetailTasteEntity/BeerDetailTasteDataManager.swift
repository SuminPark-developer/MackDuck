//
//  BeerDetailTasteDataManager.swift
//  MackDuck
//
//  Created by sumin on 2022/01/12.
//

import Foundation
import Alamofire

//let headers: HTTPHeaders = [
//    "x-access-token": UserDefaults.standard.string(forKey: "x-access-token")! // UserDefaults에서 jwt값(x-access-token) 불러옴.
//]

class BeerDetailTasteDataManager {
    // 맥주 맛/향 정보 서버에서 GET하는 함수.
    func getBeerTasteSmellInfo(beerId: Int, delegate: BeerDetailTasteViewController) {
        let pathVariable: String = String(beerId) // pathVariable - https://stackoverflow.com/questions/63041566/alamofire-add-path-variable-to-url
        
        AF.request("\(Constant.BASE_URL)/beers/\(pathVariable)/favor-smell", method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: nil)
            .validate()
            .responseDecodable(of: BeerDetailTasteResponse.self) { response in
                switch response.result {
                case .success(let response):

                    if response.isSuccess { // 성공했을 때
                        delegate.didSuccessGetBeerTasteSmellInfo(response) // BeerDetailTasteViewController의 didSuccessGetBeerTasteSmellInfo메서드 호출.
                        print("맥주 맛/향 정보 GET 성공")
                    }
                    else { // 실패했을 때
                        switch response.code {
                        case 2000: delegate.failedToGetBeerTasteSmellInfo(message: "JWT 토큰을 입력해주세요.", code: 2000)
                        case 2016: delegate.failedToGetBeerTasteSmellInfo(message: "맥주 beerId 값 확인해주세요.", code: 2016)
                        default: delegate.failedToGetBeerTasteSmellInfo(message: "에러 피드백을 주세요.", code: 4001)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedToGetBeerTasteSmellInfo(message: "서버와의 연결이 원활하지 않습니다.", code: 4444)
                }
            }
    }

}
