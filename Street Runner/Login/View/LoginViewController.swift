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
    
    private let loginViewModel: LoginViewModel = LoginViewModelimpl()
    private lazy var router: PerformAlertRouter = PerformAlertRouterImpl(viewController: self)
    
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
            loginViewModel.setUserIdToInstallation { [weak self] in
                guard let self = self else {return}
                switch $0 {
                case .success:
                    self.loginViewModel.setAcl {
                        switch $0 {
                        case .success:
                            break
                        case .failure:
                            break
                        }
                    }
                    DispatchQueue.main.async {
                        self.router.transition(idetifier: "toProfile", sender: nil)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.router.resultAlert(titleText: "ログイン失敗", messageText: "もう一度やり直してください", titleOK: "OK")
                    }
                }
            }
        case .failure:
            router.resultAlert(titleText: "ログイン失敗", messageText: "もう一度やり直してください", titleOK: "OK")
        }
    }
}
