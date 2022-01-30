//
//  AllReviewModel.swift
//  MackDuck
//
//  Created by sumin on 2022/01/28.
//

import Foundation

class AllReviewModel { // 검색결과 테이블뷰 모델
    let userCheck: String // 리뷰가 유저의 것인지 아닌지
    let reviewId: Int // 리뷰 아이디
    let nickname: String // 리뷰쓴 유저 닉네임
    let age: String // 리뷰쓴 유저 나이
    let gender: String // 리뷰쓴 유저 성별
    let beerKindId, score: Int // 리뷰쓴 유저 맥주 취향 아이디, 맥주 리뷰 평점
    let updatedAt: String // 리뷰쓴 날짜
    let description: String // 리뷰 내용
    
    let reviewLikeCount: Int // 리뷰 좋아요 개수
    let rowNumber: String // 페이징을 위한 rowNumber
    
    let reviewImgUrlList: [AllReviewImgUrlList] // 리뷰 이미지 배열
    
    init(userCheck: String, reviewId: Int, nickname: String, age: String, gender: String, beerKindId: Int, score: Int, updatedAt: String, description: String, reviewLikeCount: Int, rowNumber: String, reviewImgUrlList: [AllReviewImgUrlList]) {
        self.userCheck = userCheck
        self.reviewId = reviewId
        self.nickname = nickname
        self.age = age
        self.gender = gender
        self.beerKindId = beerKindId
        self.score = score
        self.updatedAt = updatedAt
        self.description = description
        self.reviewLikeCount = reviewLikeCount
        self.rowNumber = rowNumber
        self.reviewImgUrlList = reviewImgUrlList
    }
}

