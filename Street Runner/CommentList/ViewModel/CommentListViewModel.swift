//
//  CommentListViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/20.
//

import Foundation

protocol CommentListViewModel{
    func getObjectId() -> String
}

class CommentListViewModelImpl: CommentListViewModel{
    
    init(objectId: String){
        self.objectId = objectId
    }
    
    let objectId: String
    
    func getObjectId() -> String {
        objectId
    }
}
