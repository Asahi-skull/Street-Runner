//
//  UserRouter.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/22.
//

import Foundation

protocol UserRouter{
    
    func resultAlert(titleText: String, messageText: String, titleOK: String)
    func transition(idetifier: String)
}

class UserRouterImpl: UserRouter{
    
    let userRouterModel: UserRouterModel = UserRouterModelImpl()
    
    func resultAlert(titleText: String, messageText: String, titleOK: String) {
        userRouterModel.resultAlert(titleText: titleText, messageText: messageText, titleOK: titleOK)
    }
   
    func transition(idetifier: String) {
        userRouterModel.transition(idetifier: idetifier)
    }
}
