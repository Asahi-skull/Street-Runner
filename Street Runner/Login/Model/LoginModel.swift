//
//  LoginModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/24.
//

import Foundation

protocol LoginModel{
    func loginUser(email: String,password: String) -> Result<Void,Error>
}

class LoginModelImpl: LoginModel{
    
    let login: LoginmBaaS = LoginmBaaSImpl()
    
    func loginUser(email: String, password: String) -> Result<Void, Error> {
        login.loginEmail(emailAddress: email, password: password)
    }
}
