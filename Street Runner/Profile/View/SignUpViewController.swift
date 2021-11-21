//
//  SignUpViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/20.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    let signUpViewModel: SignUpViewModel = SignUpViewModelImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendEmailButton(_ sender: Any) {
        guard let email = emailTextField.text else {return}
        let result = signUpViewModel.sendEmail(emailText: email)
        switch result{
        case .success:
            print("確認メール送信")
            successAlert()
        case .failure(let err):
            print(err.localizedDescription)
            failureAlert()
        }
    }
    
    func successAlert() {
        let alertController = UIAlertController(title: "メールに送信完了", message: "メールを確認してください", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func failureAlert(){
        let alertController = UIAlertController(title: "メールに送信失敗", message: "もう一度やり直してください", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}
