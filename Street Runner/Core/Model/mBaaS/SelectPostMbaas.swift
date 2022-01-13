//
//  SelectPostMbaas.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/12.
//

import Foundation
import NCMB

protocol SelectPostMbaas{
    func checkUserExist() -> Bool
}

class SelectPostMbaasImpl: SelectPostMbaas{
    func checkUserExist() -> Bool {
        if NCMBUser.currentUser != nil {
            return true
        }else{
            return false
        }
    }
}
