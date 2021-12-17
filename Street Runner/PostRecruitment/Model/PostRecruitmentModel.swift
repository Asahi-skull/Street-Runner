//
//  PostRecruitmentModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/12.
//

import Foundation

protocol PostRecruitmentModel{
    func getUUID() -> String
}

class PostRecruitmentModelImpl: PostRecruitmentModel{
    func getUUID() -> String{
        let uuuid = NSUUID().uuidString
        return uuuid
    }
}
