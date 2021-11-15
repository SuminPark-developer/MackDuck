//
//  String.swift
//  MackDuck
//
//  Created by sumin on 2021/11/15.
//

import Foundation

extension String {
    
    // 이메일, 비밀번호 검증 - https://ginjo.tistory.com/15
    // 이메일 정규식
    func validateEmail() -> Bool {
        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: self)
    }
    // 비밀번호(영문, 숫자, 특수문자 포함 8자 이상) 정규식
    func validatePassword() -> Bool {
        let passwordRegEx = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&+=]).{8,}$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: self)
    }
    
}
