//
//  SignUpViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/20.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    private let signUpViewModel: SignUpViewModel = SignUpViewModelImpl()
    private lazy var router: PerformAlertRouter = PerformAlertRouterImpl(viewController: self)

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
            router.resultAlert(titleText: "送信完了", messageText: "メールを確認してください", titleOK: "OK")
            break
        case .failure:
            router.resultAlert(titleText: "送信失敗", messageText: "もう一度やり直してください", titleOK: "OK")
        }
    }
    
    @IBAction func toLoginButon(_ sender: Any) {
        router.transition(idetifier: "toLogin",sender: nil)
    }
    
}
