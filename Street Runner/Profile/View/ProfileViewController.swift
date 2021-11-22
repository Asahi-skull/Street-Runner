//
//  ProfileViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    
    let profileViewModel: ProfileViewModel = ProfileViewModelImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = profileViewModel.setUser()
    }
}
