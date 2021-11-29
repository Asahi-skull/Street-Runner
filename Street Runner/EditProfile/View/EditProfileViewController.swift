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
    
    let editProfile: EditProfileViewModel = EditProfileViewModelImpl()
    lazy var router: EditProfileRouter = EditProfileRouterImpl(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImage.layer.cornerRadius = 60
        let iconResult = editProfile.getIconImage()
        switch iconResult{
        case .success(let icon):
            iconImage.image = icon
        case .failure:
            return
        }
        userNameTextField.text = editProfile.getUserName()
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
            if editProfile.saveUserName(userName: userName){
                router.backView()
            }else{
                router.resultAlert(titleText: "ユーザーネームの保存に失敗", messageText: "もう一度やり直してください", titleOK: "OK")
                return
            }
        case .failure:
            router.resultAlert(titleText: "画像の保存に失敗", messageText: "もう一度やり直してください", titleOK: "OK")
            return
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        router.backView()
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            iconImage.image = editImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            iconImage.image = originalImage
        }
        router.backView()
    }
}
