//
//  EditProfileViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/25.
//

import UIKit

class EditProfileViewController: UIViewController{
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    
    private let editProfile: EditProfileViewModel = EditProfileViewModelImpl()
    private lazy var router: PerformAlertRouter = PerformAlertRouterImpl(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImage.layer.cornerRadius = 60
        userNameTextField.text = editProfile.getUserName()
        editProfile.getIconImage { [weak self] in
            guard let self = self else {return}
            switch $0 {
            case .success(let imageData):
                let uiImage = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.iconImage.image = uiImage
                }
            case .failure:
                return
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func editIconButton(_ sender: Any) {
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        pickerView.sourceType = UIImagePickerController.SourceType.photoLibrary
        pickerView.allowsEditing = true
        self.present(pickerView,animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: Any) {
        guard let icon = iconImage.image else {return}
        let result = editProfile.saveImage(img: icon)
        switch result{
        case .success:
            guard let userName = userNameTextField.text else {return}
            let res = editProfile.saveUserName(userName: userName)
            switch res{
            case .success:
                router.dismiss()
            case .failure:
                router.resultAlert(titleText: "すでに使われているユーザーネーム", messageText: "別の名前を入力してください", titleOK: "OK")
                return
            }
        case .failure:
            router.resultAlert(titleText: "画像の保存に失敗", messageText: "もう一度やり直してください", titleOK: "OK")
            return
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        router.dismiss()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        router.checkActAfterAlert(titleText: "ログアウトしますか？", messageText: "")
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            iconImage.image = editImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            iconImage.image = originalImage
        }
        router.dismiss()
    }
}

extension EditProfileViewController: AlertResult{
    func changeView() {
        let result = editProfile.userLogOut()
        switch result {
        case .success:
            router.transition(idetifier: "toGuest", sender: nil)
        case .failure:
            return
        }
    }
}
