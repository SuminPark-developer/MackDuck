//
//  IntroBeerDetailResponse.swift
//  MackDuck
//
//  Created by sumin on 2022/01/06.
//

import Foundation

// MARK: - IntroBeerDetailResponse
struct IntroBeerDetailResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: IntroBeerDetailResult // 여기선 대괄호 없어야 했음. 대괄호 써서 안되는 거 찾으려고 몇시간 썼었음. 주의!
}

struct IntroBeerDetailResult: Decodable {
    let beerLikeCheck: String
    let beerImgUrl: String
    let nameEn, nameKr, country, manufacturer: String
    let beerKind, alcohol, ingredient, feature: String
    let reviewAverage: String
    let reviewCount: Int
    let userReviewWrite: String
}
