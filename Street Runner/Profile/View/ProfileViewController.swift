//
//  ProfileViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    
    lazy var router: ProfileRouter = ProfileRouterImpl(viewController: self)
    
    let profileViewModel: ProfileViewModel = ProfileViewModelImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImage.layer.cornerRadius = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let iconResult = profileViewModel.getIconImage()
        switch iconResult{
        case .success(let icon):
            iconImage.image = icon
        case .failure:
            return
        }
        userNameLabel.text = "名前：" + profileViewModel.setUser()
    }
    
    @IBAction func editButton(_ sender: Any) {
        router.transition(idetifier: "toEdit")
    }
}
