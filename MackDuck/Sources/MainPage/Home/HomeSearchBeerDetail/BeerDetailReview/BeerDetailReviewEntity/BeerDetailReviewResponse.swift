//
//  BeerDetailReviewResponse.swift
//  MackDuck
//
//  Created by sumin on 2022/01/13.
//

import Foundation
// MARK: - BeerDetailReviewResponse
struct BeerDetailReviewResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: BeerDetailReviewResult
}

// MARK: - Result
struct BeerDetailReviewResult: Decodable {
    let reviewStatics: ReviewStatics
    let reviewImageList: [ReviewImageList]
    let reviewList: [ReviewList]
}

// MARK: - ReviewStatics
struct ReviewStatics: Decodable {
    let reviewCount: Int
    let reviewAverage: String
    let five, four, three, two, one: Int
}

// MARK: - ReviewImageList
struct ReviewImageList: Decodable {
    let reviewImgUrl: String
}

// MARK: - ReviewList
struct ReviewList: Decodable {
    let userCheck: String
    let reviewId: Int
    let nickname: String
    let age: String
    let gender: String
    let beerKindId, score: Int
    let updatedAt: String
    let description: String
    let reviewImgUrlList: [ReviewImgURLList]
    let reviewLikeCount: Int
    let rowNumber: String
}

// MARK: - ReviewImgURLList
struct ReviewImgURLList: Decodable {
    let reviewImageUrl: String
}



