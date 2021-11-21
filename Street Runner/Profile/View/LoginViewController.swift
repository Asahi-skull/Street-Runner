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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            performSegue(withIdentifier: "toProfile", sender: nil)
        case .failure(let err):
            print(err.localizedDescription)
            failureAlert()
        }
    }
    
    func failureAlert(){
        let alertController = UIAlertController(title: "ログイン失敗", message: "もう一度やり直してください", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
