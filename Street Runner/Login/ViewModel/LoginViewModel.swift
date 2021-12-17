//
//  LoginViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/21.
//

import Foundation

protocol LoginViewModel{
    func loginUser(email: String,password: String) -> Result<Void,Error>
}

class LoginViewModelimpl: LoginViewModel{
    let login: LoginmBaaS = LoginmBaaSImpl()
    
    func loginUser(email: String, password: String) -> Result<Void, Error> {
        login.loginEmail(emailAddress: email, password: password)
    }
}
