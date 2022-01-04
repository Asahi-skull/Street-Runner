//
//  LoginViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/21.
//

import Foundation

protocol LoginViewModel{
    func loginUser(email: String,password: String) -> Result<Void,Error>
    func setAcl(completion: @escaping (Result<Void,Error>) -> Void)
}

class LoginViewModelimpl: LoginViewModel{
    let login: LoginmBaaS = LoginmBaaSImpl()
    
    func loginUser(email: String, password: String) -> Result<Void,Error> {
        login.loginEmail(emailAddress: email, password: password)
    }
    
    func setAcl(completion: @escaping (Result<Void,Error>) -> Void) {
        login.setAcl {
            switch $0 {
            case .success:
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
}
