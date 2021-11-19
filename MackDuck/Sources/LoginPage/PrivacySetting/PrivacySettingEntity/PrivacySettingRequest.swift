//
//  PrivacySettingRequest.swift
//  MackDuck
//
//  Created by sumin on 2021/11/17.
//

import Foundation

struct PrivacySettingRequest: Encodable {
    var kakaoId: Int
    var nickname: String
    var gender: String
    var age: String
    var beerKindId: Int
}
