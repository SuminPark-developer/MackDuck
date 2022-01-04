//
//  SendBeerInfoResponse.swift
//  MackDuck
//
//  Created by sumin on 2022/01/04.
//

import Foundation


// MARK: - SendBeerInfoResponse
struct SendBeerInfoResponse: Decodable {
    let isSuccess: Bool
    let code: Int
    let message: String
}


