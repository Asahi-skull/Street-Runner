//
//  SignUpModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/24.
//

import Foundation

protocol SignUpModel{
    func sendEmail(emailText:String) -> Result<Void,Error>

}

class SignUpModelImpl: SignUpModel{
    let signUpmBaaS: SignUpmBaaS = SignUpmBaaSImpl()
    
    func sendEmail(emailText: String) -> Result<Void,Error>{
        //confirmationEmailの関数がResult型を返しているので一行でも良い
        signUpmBaaS.confirmationEmail(email: emailText)
    }
}

