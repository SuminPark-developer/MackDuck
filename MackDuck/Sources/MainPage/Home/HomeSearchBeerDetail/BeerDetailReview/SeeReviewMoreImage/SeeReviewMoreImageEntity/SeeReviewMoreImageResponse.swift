//
//  SeeReviewMoreImageResponse.swift
//  MackDuck
//
//  Created by sumin on 2022/01/17.
//

import Foundation


// MARK: - SeeReviewMoreImageResponse
struct SeeReviewMoreImageResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [SeeReviewMoreImageResult]
}

// MARK: - SeeReviewMoreImageResult
struct SeeReviewMoreImageResult: Decodable {
    let reviewId: Int
    let reviewImgUrl: String
    let rowNumber: String
}
