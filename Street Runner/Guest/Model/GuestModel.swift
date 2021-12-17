//
//  GuestModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/23.
//

import Foundation

protocol AutologinModel{
    func autoLogin() -> (String,String)?
}

class AutologinModelImpl: AutologinModel{
    func autoLogin() -> (String,String)?{
        if let emailAddress = UserDefaults.standard.string(forKey: "email"), let password = UserDefaults.standard.string(forKey: "password"){
            return (emailAddress,password)
        }else{
            return nil
        }
    }
}
