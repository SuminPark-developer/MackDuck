//
//  ReviewDetailResponse.swift
//  MackDuck
//
//  Created by sumin on 2022/02/08.
//

import Foundation


// MARK: - ReviewDetailResponse
struct ReviewDetailResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: ReviewDetailResult
}

// MARK: - ReviewDetailResult
struct ReviewDetailResult: Decodable {
    let nickname, age, gender: String
    let beerKindId, score: Int
    let updatedAt, userCheck, description: String
    let reviewLikeCount: Int
    let reviewImgUrlList: [ReviewDetailImgUrlList]
}

// MARK: - ReviewDetailImgUrlList
struct ReviewDetailImgUrlList: Decodable {
    let reviewImageUrl: String
}

