//
//  ReviewDetailLikeButtonResponse.swift
//  MackDuck
//
//  Created by sumin on 2022/02/08.
//

import Foundation
// MARK: - ReviewDetailLikeButtonResponse
struct ReviewDetailLikeButtonResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: ReviewDetailLikeButtonResult
}

// MARK: - ReviewDetailLikeButtonResult
struct ReviewDetailLikeButtonResult: Decodable {
    let AddReviewLikeId: String? // message : 도움이 됐어요 추가 성공
    let DeleteLikeReviewId: String? // message : 도움이 됐어요 삭제(INACTIVE로 수정) 성공
    let AddLikeReviewId: String? // message : 도움이 됐어요 추가(ACTIVE로 수정) 성공
    
}
