//
//  BestSearchModel.swift
//  MackDuck
//
//  Created by sumin on 2021/12/02.
//

import Foundation

struct  BestSearchModel { // 검색뷰 하단 테이블뷰 인기검색어 모델(5개)
    let beerId: Int // 맥주 아이디
    let beerImageUrl: String // 맥주 이미지 url
    let beerName: String // 맥주 이름
    let beerKind: String // 맥주 종류
    let beerAlcohol: String // 맥주 도수
    let beerFeature: String // 맥주 특징
    let beerReviewCount: String // 맥주 리뷰 개수
    
    
    init(beerId: Int, beerImageUrl: String, beerName: String, beerKind: String, beerAlcohol: String, beerFeature: String, beerReviewCount: String) {
        self.beerId = beerId
        self.beerImageUrl = beerImageUrl
        self.beerName = beerName
        self.beerKind = beerKind
        self.beerAlcohol = beerAlcohol
        self.beerFeature = beerFeature
        self.beerReviewCount = beerReviewCount
    }
}
