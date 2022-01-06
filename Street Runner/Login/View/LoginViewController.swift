//
//  LoginViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let loginViewModel: LoginViewModel = LoginViewModelimpl()
    lazy var router: LoginRouter = LoginRouterImpl(viewController: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginButton(_ sender: Any) {
        guard let emailText = emailTextField.text else {return}
        guard let passwordText = passwordTextField.text else {return}
        let result = loginViewModel.loginUser(email: emailText, password: passwordText)
        switch result {
        case .success:
            UserDefaults.standard.set(emailText, forKey:"email")
            UserDefaults.standard.set(passwordText, forKey: "password")
            loginViewModel.setAcl {
                switch $0 {
                case .success:
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toProfile", sender: nil)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toProfile", sender: nil)
                    }
                }
            }
        case .failure:
            DispatchQueue.main.async {
                self.router.resultAlert(titleText: "ログイン失敗", messageText: "もう一度やり直してください", titleOK: "OK")
            }
        }
    }
}
