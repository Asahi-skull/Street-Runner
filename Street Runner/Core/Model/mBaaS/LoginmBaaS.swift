//
//  LoginModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/21.
//

import Foundation
import NCMB

protocol LoginmBaaS{
    func loginEmail(emailAddress: String,password: String) -> Result<Void,Error>
    func setAcl(completion: @escaping (Result<Void,Error>) -> Void) 
}

class LoginmBaaSImpl: LoginmBaaS{
    func loginEmail(emailAddress: String, password: String) -> Result<Void, Error> {
        let result = NCMBUser.logIn(mailAddress: emailAddress, password: password)
        switch result{
        case .success:
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func setAcl(completion: @escaping (Result<Void,Error>) -> Void) {
        var acl = NCMBACL.empty
        acl.put(key: "*", readable: true, writable: false)
        if let user = NCMBUser.currentUser{
            user.acl = acl
            user.saveInBackground{
                switch $0 {
                case .success:
                    completion(Result.success(()))
                case .failure(let err):
                    completion(Result.failure(err))
                }
            }
        }else{
            return
        }
    }
}
