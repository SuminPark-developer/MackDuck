//
//  PrivacySettingResponse.swift
//  MackDuck
//
//  Created by sumin on 2021/11/17.
//

import Foundation


struct PrivacySettingResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: PrivacySettingResult?
}

struct PrivacySettingResult: Decodable {
    var userId: Int
    var nickname: String
    var jwt: String
}
