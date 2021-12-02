//
//  HomeRecentDeleteResponse.swift
//  MackDuck
//
//  Created by sumin on 2021/12/02.
//

import Foundation

struct HomeRecentDeleteResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
//    var result: NicknameResult?
}

//struct HomeRecentDeleteResult: Decodable {
//    var nickname: String?
//}
