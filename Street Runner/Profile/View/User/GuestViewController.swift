//
//  GuestViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/20.
//

import UIKit

class GuestViewController: UIViewController {
    
    let loginViewModel: LoginViewModel = LoginViewModelimpl()
    let userRouter: UserRouter = UserRouterImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if loginViewModel.autoLogin() == true{
            userRouter.transition(idetifier: "fromGuest")
        }
    }

    @IBAction func registerButton(_ sender: Any) {
        userRouter.transition(idetifier: "toSignUp")
    }
    
}
