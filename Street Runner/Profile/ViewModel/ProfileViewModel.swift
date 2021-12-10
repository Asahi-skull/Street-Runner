//
//  ProfileViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/22.
//

import Foundation
import UIKit

protocol ProfileViewModel{
    func setUser() -> String
    func getIconImage() -> Result<UIImage,Error>
    func dataCount() -> Int
    func getData(indexPath: IndexPath) -> ProfilePostedEntity
    func getRequest() -> Result<Void,Error>
    func getImage(fileName: String,imageView: UIImageView)
}

class ProfileViewModelImpl: ProfileViewModel{
    let profileModel: ProfileModel = ProfileModelImpl()
    private var datas: [ProfilePostedEntity] = []
    
    func setUser() -> String {
        profileModel.setUser()
    }
    
    func getIconImage() -> Result<UIImage,Error>{
        let fileName = profileModel.getId()
        let imageResult = profileModel.getIconImage(fileName: fileName)
        return imageResult
    }
    
    func dataCount() -> Int {
        datas.count
    }
    
    func getData(indexPath: IndexPath) -> ProfilePostedEntity {
        datas[indexPath.row]
    }
    
    func getRequest() -> Result<Void,Error> {
        let result = profileModel.getRequest(className: "request", userName: profileModel.setUser())
        switch result{
        case .success(let datas):
            self.datas = datas
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func getImage(fileName: String,imageView: UIImageView){
        profileModel.getImage(fileName: fileName, imageView: imageView)
    }
}
