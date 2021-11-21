//
//  LoginModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/21.
//

import Foundation
import NCMB

protocol LoginModel{
    
    func loginEmail(emailAddress: String,password: String) -> Result<Void,Error>
}

class LoginModelImpl: LoginModel{
    
    func loginEmail(emailAddress: String, password: String) -> Result<Void, Error> {
        let result = NCMBUser.logIn(mailAddress: emailAddress, password: password)
        switch result{
        case .success:
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
}
