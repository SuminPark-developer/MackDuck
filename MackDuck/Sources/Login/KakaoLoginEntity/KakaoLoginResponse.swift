//
//  KakaoLoginResponse.swift
//  MackDuck
//
//  Created by sumin on 2021/11/16.
//

import Foundation


struct KakaoLoginResponse: Decodable {
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: KakaoLoginResult?
}

// kakaoId값이 있으면 -> 신규 가입
// kakaoId값이 없으면 -> 재로그인
struct KakaoLoginResult: Decodable {
    var nickname: String?
    var userId: Int?
    var jwt: String?
    var kakaoId: Int?
}
