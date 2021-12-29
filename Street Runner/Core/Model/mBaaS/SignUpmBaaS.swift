//
//  SignUpModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/21.
//

import Foundation
import NCMB

protocol SignUpmBaaS{
    func confirmationEmail(email: String) -> Result<Void,Error>
}

class SignUpmBaaSImpl: SignUpmBaaS{
    func confirmationEmail(email: String) -> Result<Void,Error>{
        let result = NCMBUser.requestAuthenticationMail(mailAddress: email)
        switch result{
        case .success:
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
}
