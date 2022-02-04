//
//  AllReviewReportButtonResponse.swift
//  MackDuck
//
//  Created by sumin on 2022/02/04.
//

import Foundation

// MARK: - AllReviewReportButtonResponse
struct AllReviewReportButtonResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
}
