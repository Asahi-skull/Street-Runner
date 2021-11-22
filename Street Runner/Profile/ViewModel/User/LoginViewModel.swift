//
//  LoginViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/21.
//

import Foundation

protocol LoginViewModel{
    
    func loginUser(email: String,password: String) -> Result<Void,Error>
    func autoLogin() -> Bool
}

class LoginViewModelimpl: LoginViewModel{
    
    let loginModel: LoginModel = LoginModelImpl()
    
    func loginUser(email: String, password: String) -> Result<Void, Error> {
        loginModel.loginEmail(emailAddress: email, password: password)
    }
    
    //自動ログイン
    func autoLogin() -> Bool{
        
        if let emailAddress = UserDefaults.standard.string(forKey: "email"), let password = UserDefaults.standard.string(forKey: "password"){
            loginModel.loginEmail(emailAddress: emailAddress , password: password)
            return true
        }else{
            return false
        }
    }
}
