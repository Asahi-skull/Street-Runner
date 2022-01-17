//
//  EditProfileViewModel.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/25.
//

import Foundation
import UIKit

protocol EditProfileViewModel{
    func saveImage(img: UIImage) -> Result<Void,Error>
    func getIconImage(completion: @escaping (Result<Data,Error>) -> Void)
    func getUserName() -> String
    func saveUserName(userName: String) ->  Result<Void,Error>
    func userLogOut() -> Result<Void,Error>
}

class EditProfileViewModelImpl: EditProfileViewModel{
    private let editProfile: EditProfilemBaaSImpl = EditProfilemBaaSImpl()
    private let profile: ProfilemBaaS = ProfilemBaaSImpl()
    private let showPosted: ShowPostedMBaaS = ShowPostedMBaaSImpl()
    
    func saveImage(img: UIImage) -> Result<Void,Error> {
        let fileName = profile.getID()
        let result = editProfile.saveImageFile(img: img, fileName: fileName)
        switch result{
        case .success:
            let res = editProfile.saveImageuser(fileName: fileName)
            switch res{
            case .success:
                break
            case .failure(let err):
                return Result.failure(err)
            }
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
    
    func getIconImage(completion: @escaping (Result<Data,Error>) -> Void) {
        showPosted.getIconImage(fileName: profile.getID()) {
            switch $0 {
            case .success(let imageData):
                completion(Result.success(imageData))
            case .failure(let err):
                completion(Result.failure(err))
            }
        }
    }
    
    func getUserName() -> String {
        profile.getUser()
    }
    
    func saveUserName(userName: String) ->  Result<Void,Error>{
        editProfile.saveUserName(userName: userName)
    }
    
    func userLogOut() -> Result<Void,Error> {
        let result = editProfile.userLogOut()
        switch result {
        case .success:
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "password")
            return Result.success(())
        case .failure(let err):
            return Result.failure(err)
        }
    }
}
