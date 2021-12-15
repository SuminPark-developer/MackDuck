//
//  HomeRecentPopularResponse.swift
//  MackDuck
//
//  Created by sumin on 2021/12/01.
//

import Foundation

//struct HomeRecentPopularResponse: Decodable {
//    var isSuccess: Bool
//    var code: Int
//    var message: String
//    var result: HomeRecentPopularResult? // 최근&인기 검색어
//}
//
//
//struct HomeRecentPopularResult: Decodable {
//    var RecentKeyword: HomeRecentResult? // 최근 검색어
//    var PopularBeer: HomePopularResult? // 인기 검색어
//}
//
//struct HomeRecentResult: Decodable { // 최근 검색어
//    var keyword: String?
//    var createdAt: String?
//}
//
//struct HomePopularResult: Decodable { // 인기 검색어
//    var beerId: Int?
//    var beerImgUrl: String?
//    var nameKr: String?
//    var beerKind: String?
//    var alcohol: String?
//    var feature: String?
//    var reviewCount: Int?
//}


// MARK: - HomeRecentPopularResponse
struct HomeRecentPopularResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: HomeRecentPopularResult // 최근&인기 검색어
}

// MARK: - Result(최근&인기 검색어)
struct HomeRecentPopularResult: Codable {
    let recentKeyword: [RecentKeyword] // 최근 검색어
    let popularBeer: [PopularBeer] // 인기 검색어

    enum CodingKeys: String, CodingKey {
        case recentKeyword = "RecentKeyword"
        case popularBeer = "PopularBeer"
    }
}

// MARK: - RecentKeyword(최근 검색어)
struct RecentKeyword: Codable {
    let keyword, createdAt: String
}

// MARK: - PopularBeer(인기 검색어)
struct PopularBeer: Codable {
    let beerID: Int
    let beerImgURL: String
    let nameKr, beerKind, alcohol, feature: String
    let reviewCount: Int

    enum CodingKeys: String, CodingKey {
        case beerID = "beerId"
        case beerImgURL = "beerImgUrl"
        case nameKr, beerKind, alcohol, feature, reviewCount
    }
}

