//
//  SignUpViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/20.
//

import UIKit
import NCMB

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    let signUpViewModel: SignUpViewModel = SignUpViewModelImpl()
    let userRouter: UserRouter = UserRouterImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendEmailButton(_ sender: Any) {
        guard let email = emailTextField.text else {return}
        let result = signUpViewModel.sendEmail(emailText: email)
        switch result{
        case .success:
            userRouter.resultAlert(titleText: "メールに送信完了", messageText: "メールを確認してください", titleOK: "OK")
        case .failure(let err):
            print(err.localizedDescription)
            userRouter.resultAlert(titleText: "メールに送信失敗", messageText: "もう一度やり直してください", titleOK: "OK")
        }
    }
    
    @IBAction func toLoginButon(_ sender: Any) {
        userRouter.transition(idetifier: "toLogin")
    }
    
}
