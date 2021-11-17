//
//  NicknameResponse.swift
//  MackDuck
//
//  Created by sumin on 2021/11/17.
//

import Foundation

struct NicknameResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: NicknameResult?
}

struct NicknameResult: Decodable {
    var nickname: String?
}
