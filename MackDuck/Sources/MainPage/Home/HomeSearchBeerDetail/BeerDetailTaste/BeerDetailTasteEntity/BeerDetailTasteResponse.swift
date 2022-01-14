//
//  BeerDetailTasteResponse.swift
//  MackDuck
//
//  Created by sumin on 2022/01/12.
//

import Foundation
// MARK: - BeerDetailTasteResponse
struct BeerDetailTasteResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: BeerDetailTasteResult
}

// MARK: - Result
struct BeerDetailTasteResult: Decodable {
    let favorList: [FavorList]
    let smellList: [SmellList]
}

// MARK: - FavorList
struct FavorList: Decodable {
    let favor: String
}

// MARK: - SmellList
struct SmellList: Decodable {
    let smell: String
}
