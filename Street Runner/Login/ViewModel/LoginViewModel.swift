//
//  LoginViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/21.
//

import Foundation

protocol LoginViewModel{
    func loginUser(email: String, password: String,completion: @escaping (Result<Void,Error>) -> Void)
}

class LoginViewModelimpl: LoginViewModel{
    let login: LoginmBaaS = LoginmBaaSImpl()
    
    func loginUser(email: String, password: String,completion: @escaping (Result<Void,Error>) -> Void) {
        let result = login.loginEmail(emailAddress: email, password: password)
        switch result {
        case .success:
            login.setAcl {
                switch $0 {
                case .success:
                    completion(Result.success(()))
                case .failure(let err):
                    completion(Result.failure(err))
                }
            }
        case .failure(let err):
            completion(Result.failure(err))
            return
        }
    }
}
