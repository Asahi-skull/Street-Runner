//
//  ProfileModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/25.
//

import Foundation

protocol ProfileModel{
    func setUser() -> String
}

class ProfileModelImpl: ProfileModel{
    let profile: ProfilemBaaS = ProfilemBaaSImpl()
    
    func setUser() -> String{
        profile.getUser()
    }
}
