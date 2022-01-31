//
//  AllReviewLikeButtonResponse.swift
//  MackDuck
//
//  Created by sumin on 2022/01/31.
//

import Foundation

// MARK: - AllReviewLikeButtonResponse
struct AllReviewLikeButtonResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: AllReviewLikeButtonResult
}

// MARK: - AllReviewLikeButtonResult
struct AllReviewLikeButtonResult: Decodable {
    let AddReviewLikeId: String? // message : 도움이 됐어요 추가 성공
    let DeleteLikeReviewId: String? // message : 도움이 됐어요 삭제(INACTIVE로 수정) 성공
    let AddLikeReviewId: String? // message : 도움이 됐어요 추가(ACTIVE로 수정) 성공
    
}
