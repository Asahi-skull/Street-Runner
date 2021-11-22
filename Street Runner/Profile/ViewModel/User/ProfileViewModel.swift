//
//  ProfileViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/22.
//

import Foundation

protocol ProfileViewModel{
    
    func setUser() -> String
}

class ProfileViewModelImpl: ProfileViewModel{
    
    let profileModel: ProfileModel = ProfileModelImpl()
    
    func setUser() -> String {
        let name = profileModel.getUser()
        return name
    }
}
