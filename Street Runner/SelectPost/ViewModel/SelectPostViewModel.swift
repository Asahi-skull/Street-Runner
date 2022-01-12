//
//  SelectPostViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/12.
//

import Foundation

protocol SelectPostViewModel{
    func checkUserExist() -> Bool 
}

class SelectPostViewModelImpl: SelectPostViewModel{
    private let selectPostModel: SelectPostMbaas = SelectPostMbaasImpl()
    
    func checkUserExist() -> Bool {
        selectPostModel.checkUserExist()
    }
}
