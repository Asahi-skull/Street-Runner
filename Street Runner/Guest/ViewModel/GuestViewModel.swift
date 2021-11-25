//
//  GuestViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/23.
//

import Foundation

protocol GuestViewModel{
    
    func autoLogin() -> Bool
}

class GuestViewModelImpl: GuestViewModel{
    let autoLoginModel: AutologinModel = AutologinModelImpl()
    let loginmBaaS: LoginmBaaS = LoginmBaaSImpl()
    
    func autoLogin() -> Bool{
        if let user = autoLoginModel.autoLogin(){
            let result = loginmBaaS.loginEmail(emailAddress: user.0, password: user.1)
            switch result{
            case .success:
                return true
            case .failure:
                return false
            }
        }else{
            return false
        }
    }
}
