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
    
    func sendEmail(emailText: String) -> Result<Void,Error> {
        let result = signUpModel.confirmationEmail(email: emailText)
        switch result{
        case .success:
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
}
