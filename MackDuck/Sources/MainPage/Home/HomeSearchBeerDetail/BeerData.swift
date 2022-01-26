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
    
    var beerId: Int = 0 // 맛향 VC(BeerDetailTasteViewController)에서 사용함.
    var seeReviewMoreImageRowNumber: String = "" // 리뷰탭 VC에서 사용함.
    var seeReviewMoreImageCount: Int = 0
}
