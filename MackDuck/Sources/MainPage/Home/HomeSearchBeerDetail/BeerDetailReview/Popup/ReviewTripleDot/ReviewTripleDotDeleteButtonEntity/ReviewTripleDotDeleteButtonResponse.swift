//
//  ReviewTripleDotDeleteButtonResponse.swift
//  MackDuck
//
//  Created by sumin on 2022/02/06.
//

import Foundation

// MARK: - ReviewTripleDotDeleteButtonResponse
struct ReviewTripleDotDeleteButtonResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: ReviewTripleDotDeleteButtonResult
}

// MARK: - Result
struct ReviewTripleDotDeleteButtonResult: Decodable {
    let DeleteReviewId: String
}
