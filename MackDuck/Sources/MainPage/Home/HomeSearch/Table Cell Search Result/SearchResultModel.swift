//
//  SearchResultModel.swift
//  MackDuck
//
//  Created by sumin on 2021/12/15.
//

import Foundation

class SearchResultModel { // 검색결과 테이블뷰 모델
    let beerId: Int // 맥주 아이디
    let beerImageUrl: String // 맥주 이미지 url
    let beerNameEn: String // 맥주 이름(영어)
    let beerNameKr: String // 맥주 이름(한글)
    let beerReviewAverage: String // 맥주 리뷰 평점(ex:3.5)
    let beerReviewCount: Int // 맥주 리뷰 개수
    
    init(beerId: Int, beerImageUrl: String, beerNameEn: String, beerNameKr: String, beerReviewAverage: String, beerReviewCount: Int) {
        self.beerId = beerId
        self.beerImageUrl = beerImageUrl
        self.beerNameEn = beerNameEn
        self.beerNameKr = beerNameKr
        self.beerReviewAverage = beerReviewAverage
        self.beerReviewCount = beerReviewCount
    }
}
