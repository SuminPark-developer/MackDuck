//
//  HomeSearchResultResponse.swift
//  MackDuck
//
//  Created by sumin on 2021/12/15.
//

import Foundation

// MARK: - HomeSearchResultResponse
struct HomeSearchResultResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [HomeSearchResultResult]
}

struct HomeSearchResultResult: Decodable {
    let beerId: Int
    let beerImgUrl: String
    let nameEn, nameKr, reviewAverage: String
    let reviewCount: Int
}

