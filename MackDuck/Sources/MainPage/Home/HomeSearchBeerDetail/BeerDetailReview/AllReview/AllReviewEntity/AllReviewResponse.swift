//
//  AllReviewResponse.swift
//  MackDuck
//
//  Created by sumin on 2022/01/28.
//

import Foundation


// MARK: - AllReviewResponse
struct AllReviewResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: AllReviewResult
}

// MARK: - Result
struct AllReviewResult: Decodable {
    let reviewCount: Int
    let reviewList: [AllReviewList]
}

// MARK: - ReviewList
struct AllReviewList: Decodable {
    let userCheck: String
    let reviewId: Int
    let nickname: String
    let age: String
    let gender: String
    let beerKindId, score: Int
    let updatedAt: String
    let description: String
    let reviewImgUrlList: [AllReviewImgUrlList]
    let reviewLikeCount: Int
    let rowNumber: String
}

// MARK: - ReviewImgURLList
struct AllReviewImgUrlList: Decodable {
    let reviewImageUrl: String
}

