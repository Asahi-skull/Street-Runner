//
//  PostRecruitmentViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/12.
//

import UIKit
import GoogleMobileAds

class PostRecruitmentViewController: UIViewController,GADFullScreenContentDelegate {
    
    @IBOutlet weak var recruitmentImage: UIImageView!
    @IBOutlet weak var recruitmentText: UITextView!
    
    private let viewModel: PostRecruitmentViewModel = PostRecruitmentViewModelImpl()
    private lazy var router: PerformAlertRouter = PerformAlertRouterImpl(viewController: self)
    private var interstitial: GADInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recruitmentText.layer.borderColor = UIColor.black.cgColor
        recruitmentText.layer.borderWidth = 0.7
        recruitmentText.layer.cornerRadius = 10.0
        getAd()
    }
    
    private func getAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: request) { [weak self] (ad,err) in
            guard let self = self else {return}
            if err != nil {
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func selectImageButton(_ sender: Any) {
        let pickerView = UIImagePickerController()
        pickerView.delegate = self
        pickerView.sourceType = UIImagePickerController.SourceType.photoLibrary
        pickerView.allowsEditing = true
        self.present(pickerView,animated: true, completion: nil)
    }
    
    @IBAction func postButton(_ sender: Any) {
        if recruitmentImage.image == UIImage(systemName: "photo"){
            router.resultAlert(titleText: "投稿写真をセットしていません", messageText: "やり直してください", titleOK: "OK")
            return
        }
        if recruitmentText.text.isEmpty{
            router.resultAlert(titleText: "募集内容の記述がありません", messageText: "やり直してください", titleOK: "OK")
            return
        }
        guard let recruitmentImage = recruitmentImage.image else {return}
        guard let recruitText = recruitmentText.text else {return}
        let result = viewModel.saveImageFile(img: recruitmentImage)
        switch result{
        case .success(let fileName):
            let res = viewModel.saveRecruitment(requestImageFile: fileName, requestText: recruitText)
            switch res{
            case .success:
                if interstitial != nil{
                    interstitial?.present(fromRootViewController: self)
                }
                router.popBackView()
            case .failure:
                router.resultAlert(titleText: "投稿内容の保存に失敗", messageText: "もう一度やり直してください", titleOK: "OK")
                viewModel.deleteImageFile(fileName: fileName)
                return
            }
        case .failure:
            router.resultAlert(titleText: "写真の保存に失敗しました", messageText: "もう一度やり直してください", titleOK: "OK")
            return
        }
    }
}

extension PostRecruitmentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            recruitmentImage.image = editImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            recruitmentImage.image = originalImage
        }
        router.dismiss()
    }
}
