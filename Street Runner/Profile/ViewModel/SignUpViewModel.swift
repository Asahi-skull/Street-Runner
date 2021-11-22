//
//  SignUpViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/20.
//

import Foundation

protocol SignUpViewModel{
    
    func sendEmail(emailText:String) -> Result<Void,Error>
}

class SignUpViewModelImpl: SignUpViewModel{
    
    let signUpModel: SignUpModel = SignUpModelImpl()
    
    func sendEmail(emailText: String) -> Result<Void,Error>{
        //confirmationEmailの関数がResult型を返しているので一行でも良い
        signUpModel.confirmationEmail(email: emailText)
    }
}
