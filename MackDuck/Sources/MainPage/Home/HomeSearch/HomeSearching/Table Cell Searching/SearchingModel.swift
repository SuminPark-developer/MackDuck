//
//  SearchingModel.swift
//  MackDuck
//
//  Created by sumin on 2021/12/21.
//

import Foundation

class SearchingModel { // 검색중 테이블뷰 모델
    let beerId: Int // 맥주 아이디
    let beerNameEn: String // 맥주 이름(영어)
    let beerNameKr: String // 맥주 이름(한글)
    
    init(beerId: Int, beerNameEn: String, beerNameKr: String) {
        self.beerId = beerId
        self.beerNameEn = beerNameEn
        self.beerNameKr = beerNameKr
    }
}
