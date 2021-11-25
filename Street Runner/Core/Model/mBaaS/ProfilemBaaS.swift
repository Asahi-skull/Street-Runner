//
//  ProfileModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/22.
//

import Foundation
import NCMB

protocol ProfilemBaaS{
    func getUser() -> String
}

class ProfilemBaaSImpl: ProfilemBaaS{
    func getUser() -> String {
        guard let user = NCMBUser.currentUser else {return ""}
        guard let userName = user.userName else {return ""}
        return userName
    }
}
