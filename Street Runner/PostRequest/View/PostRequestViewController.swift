//
//  PostRequestViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/01.
//

import UIKit

class PostRequestViewController: UIViewController {

    @IBOutlet weak var requestImage: UIImageView!
    @IBOutlet weak var requestTextView: UITextView!
    
    private let postRequest: PostRequestViewModel = PostRequestViewModelImpl()
    private lazy var router: PerformAlertRouter = PerformAlertRouterImpl(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTextView.layer.borderColor = UIColor.black.cgColor
        requestTextView.layer.borderWidth = 0.7
        requestTextView.layer.cornerRadius = 10.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func selectPhotoButton(_ sender: Any) {
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        pickerView.sourceType = UIImagePickerController.SourceType.photoLibrary
        pickerView.allowsEditing = true
        self.present(pickerView,animated: true, completion: nil)
    }
    
    @IBAction func postButton(_ sender: Any) {
        if requestImage.image == UIImage(systemName: "photo"){
            router.resultAlert(titleText: "投稿写真をセットしていません", messageText: "やり直してください", titleOK: "OK")
            return
        }
        if requestTextView.text.isEmpty{
            router.resultAlert(titleText: "依頼内容の記述がありません", messageText: "やり直してください", titleOK: "OK")
            return
        }
        guard let requestImage = requestImage.image else {return}
        guard let requestText = requestTextView.text else {return}
        let result = postRequest.saveImageFile(img: requestImage)
        switch result{
        case .success(let data):
            let fileName = data
            let res = postRequest.saveRequest(requestImageFile: fileName, requestText: requestText)
            switch res{
            case .success:
                router.popBackView()
            case .failure:
                router.resultAlert(titleText: "投稿内容の保存に失敗", messageText: "もう一度やり直してください", titleOK: "OK")
                postRequest.deleteImageFile(fileName: fileName)
                return
            }
        case .failure:
            router.resultAlert(titleText: "写真の保存に失敗しました", messageText: "もう一度やり直してください", titleOK: "OK")
            return
        }
    }
    
}

extension PostRequestViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            requestImage.image = editImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            requestImage.image = originalImage
        }
        router.dismiss()
    }
}
