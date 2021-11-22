//
//  GuestViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/20.
//

import UIKit

class GuestViewController: UIViewController {
    
    let loginViewModel: LoginViewModel = LoginViewModelimpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginViewModel.autoLogin()
        performSegue(withIdentifier: "fromGuest", sender: nil)
    }

    @IBAction func registerButton(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
}
