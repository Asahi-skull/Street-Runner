//
//  PostRequestModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/01.
//

import Foundation

protocol PostRequestModel{
    func getUUID() -> String
}

class PostRequestModelImpl: PostRequestModel{
    func getUUID() -> String{
        let uuuid = NSUUID().uuidString
        return uuuid
    }
}
