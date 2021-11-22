//
//  SignUpModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/21.
//

import Foundation
import NCMB

protocol SignUpModel{
    
    func confirmationEmail(email: String) -> Result<Void,Error>
}

class SignUpModelImpl: SignUpModel{
    
    func confirmationEmail(email: String) -> Result<Void,Error>{
        let result = NCMBUser.requestAuthenticationMail(mailAddress: email)
        switch result{
        case .success:
            print("成功")
            return Result.success(())
        case .failure(let err):
            print(err.localizedDescription)
            return Result.failure(err)
        }
    }
}
