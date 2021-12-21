//
//  HomeSearchingResponse.swift
//  MackDuck
//
//  Created by sumin on 2021/12/21.
//

import Foundation

// MARK: - HomeSearchingResponse
struct HomeSearchingResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [HomeSearchingResult]
}

struct HomeSearchingResult: Decodable {
    let beerId: Int
    let nameEn, nameKr: String
}

