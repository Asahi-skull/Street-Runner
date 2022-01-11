//
//  FollowCommentListViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/11.
//

import Foundation
import UIKit

protocol FollowCommentListViewModel{
    func getObjectId() -> commentData
    func saveComment(commentText: String,completion: @escaping (Result<Void,Error>) -> Void)
    func getComment(completion: @escaping (Result<Void,Error>) -> Void)
    func dataCount() -> Int
    func getData() -> [CommentEntity]
    func getUserData(userObjectId: String,completion: @escaping (Result<UserData,Error>) -> Void)
    func getIconImage(fileName: String,imageView: UIImageView)
    func getCurrentUserObjectId() -> String
    func changeGoodValue(objectId: String,value: Bool,completion: @escaping (Result<Void,Error>) -> Void)
    func changeToTrue(cellRow: Int)
    func changeTofalse(cellRow: Int)
}

class FollowCommentListViewModelImpl: FollowCommentListViewModel{
    init(entiry: commentData){
        self.entity = entiry
    }
    
    private let entity: commentData
    private var datas: [CommentEntity] = []
    
    private let commentMbaas: CommentMBaaS = CommentMBaaSImpl()
    private let iconMbaas: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    private let profileModel: ProfilemBaaS = ProfilemBaaSImpl()
    
    func getObjectId() -> commentData {
        entity
    }
    
    func saveComment(commentText: String,completion: @escaping (Result<Void,Error>) -> Void){
        guard let objectId = entity.objectId else {return}
        guard let className = entity.className else {return}
        let userObjectId = profileModel.getID()
        commentMbaas.saveComment(commentText: commentText,postedClassName: className, postedObjectId: objectId, userObjectId: userObjectId) {
            switch $0{
            case .success:
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getComment(completion: @escaping (Result<Void,Error>) -> Void){
        guard let className = entity.className else {return}
        guard let objectId = entity.objectId else {return}
        commentMbaas.getcomment(postedClassName: className,postedObjectId: objectId) { [weak self] in
            guard let self = self else {return}
            switch $0{
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
    
    func getData() -> [CommentEntity] {
        datas
    }
    
    func getUserData(userObjectId: String,completion: @escaping (Result<UserData,Error>) -> Void){
        commentMbaas.getUserData(userObjectId: userObjectId) {
            switch $0{
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
    
    func getCurrentUserObjectId() -> String {
        profileModel.getID()
    }
    
    func changeGoodValue(objectId: String,value: Bool,completion: @escaping (Result<Void,Error>) -> Void) {
        commentMbaas.changeGoodValue(objectId: objectId, value: value) {
            switch $0 {
            case .success:
                completion(Result.success(()))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func changeToTrue(cellRow: Int) {
        datas[cellRow].good = true
    }
    
    func changeTofalse(cellRow: Int) {
        datas[cellRow].good = false
    }
}
