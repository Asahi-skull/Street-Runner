//
//  CommentListViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/20.
//

import Foundation
import CoreText
import UIKit

protocol CommentListViewModel{
    func getObjectId() -> commentData
    func saveComment(commentText: String,completion: @escaping (Result<Void,Error>) -> Void)
    func getComment(completion: @escaping (Result<Void,Error>) -> Void)
    func dataCount() -> Int
    func getData(indexPath: IndexPath) -> CommentEntity
    func getUserData(completion: @escaping (Result<UserData,Error>) -> Void)
    func getIconImage(fileName: String,imageView: UIImageView)
}

class CommentListViewModelImpl: CommentListViewModel{
    let commentMbaas: CommentMBaaS = CommentMBaaSImpl()
    let iconMbaas: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    
    init(entiry: commentData){
        self.entity = entiry
    }
    
    let entity: commentData
    private var datas: [CommentEntity] = []
    
    func getObjectId() -> commentData {
        entity
    }
    
    func saveComment(commentText: String,completion: @escaping (Result<Void,Error>) -> Void){
        guard let objectId = entity.objectId else {return}
        guard let className = entity.className else {return}
        guard let userObjectId = entity.userObjectId else {return}
        let postedObjectId = objectId + className
        commentMbaas.saveComment(commentText: commentText, postedObjectId: postedObjectId, userObjectId: userObjectId) { result in
            switch result{
            case .success:
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getComment(completion: @escaping (Result<Void,Error>) -> Void){
        guard let objectId = entity.objectId else {return}
        guard let className = entity.className else {return}
        let postedObjectId = objectId + className
        print(postedObjectId)
        commentMbaas.getcomment(postedObjectId: postedObjectId) { result in
            switch result{
            case .success(let data):
                self.datas = data
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func dataCount() -> Int{
        datas.count
    }
    
    func getData(indexPath: IndexPath) -> CommentEntity{
        datas[indexPath.row]
    }
    
    func getUserData(completion: @escaping (Result<UserData,Error>) -> Void){
        guard let userObjectId = entity.userObjectId else {return}
        print(userObjectId)
        commentMbaas.getUserData(userObjectId: userObjectId) { result in
            switch result{
            case .success(let data):
                completion(Result.success(data))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getIconImage(fileName: String,imageView: UIImageView){
        iconMbaas.getIconImage(fileName: fileName, imageView: imageView)
    }
}
