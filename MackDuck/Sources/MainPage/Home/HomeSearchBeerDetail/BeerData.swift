//
//  BeerData.swift
//  MackDuck
//
//  Created by sumin on 2022/01/12.
//

import Foundation

// https://stackoverflow.com/questions/54516032/xcode-10-swift-4-how-do-i-transfer-data-across-multiple-view-controllers

struct BeerData {
    static var details: BeerData = BeerData()
    
    var userReviewWrite: String = "N" // 유저가 리뷰를 1번이라도 썼는지 안 썼는지 유무 저장할 변수. - BeerDetailReviewViewController에서 사용함.
    var beerId: Int = 0 // 맛향 VC(BeerDetailTasteViewController)에서 사용함.
    
    var seeReviewMoreImageRowNumber: String = "" // 리뷰탭 VC의 컬렉션뷰 무한스크롤에서 사용함.
    var seeReviewMoreImageCount: Int = 0 // (무한 스크롤을 위한) 모든 이미지 개수 저장.
    
    var seeAllReviewRowNumber: String = "" // 전체 리뷰 VC의 테이블뷰 무한스크롤에서 사용함.
    var seeAllReviewCount: Int = 0 // (무한 스크롤을 위한) 모든 리뷰 개수 저장.
}
