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
    
    let signModel: SignUpModel = SignUpModelImpl()
        
    func sendEmail(emailText: String) -> Result<Void,Error>{
        signModel.sendEmail(emailText: emailText)
    }
}
