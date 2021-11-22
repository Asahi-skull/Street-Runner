//
//  LoginViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/21.
//

import Foundation

protocol LoginViewModel{
    
    func loginUser(email: String,password: String) -> Result<Void,Error>
    func autoLogin()
}

class LoginViewModelimpl: LoginViewModel{
    
    let loginModel: LoginModel = LoginModelImpl()
    
    func loginUser(email: String, password: String) -> Result<Void, Error> {
        loginModel.loginEmail(emailAddress: email, password: password)
    }
    
    //自動ログイン
    func autoLogin(){
        
        if let emailAddress = UserDefaults.standard.object(forKey: "email"), let password = UserDefaults.standard.object(forKey: "password"){
            loginModel.loginEmail(emailAddress: emailAddress as! String, password: password as! String)
        }else{
            return
        }
    }
}
