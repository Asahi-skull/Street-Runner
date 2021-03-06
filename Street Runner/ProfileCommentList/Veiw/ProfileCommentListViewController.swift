//
//  ProfileCommentListViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/10.
//

import UIKit

class ProfileCommentListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentBottom: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    
    private var viewModel: ProfileCommentListViewModel?
    private lazy var router: PerformAlertRouter = PerformAlertRouterImpl(viewController: self)
    var entity: ProfileCommentData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let entity = entity {
            viewModel = ProfileCommentListViewModelImpl(entity: entity)
        }else{
            router.changeViewAfterAlert(titleText: "データの取得に失敗", messageText: "戻る", titleOK: "OK")
            return
        }
        viewModel.map{
            $0.getComment { [weak self] in
                guard let self = self else {return}
                switch $0{
                case .success:
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.router.resultAlert(titleText: "データの取得に失敗", messageText: "再試行してください", titleOK: "OK")
                    }
                }
            }
        }
        tabBarController?.tabBar.isHidden = true
        let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "commentCell")
        commentTextView.layer.borderColor = UIColor.black.cgColor
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.cornerRadius = 10.0
        closeButton.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if commentBottom.constant == 15{
                commentBottom.constant = keyboardSize.height - 30
                closeButton.isHidden = false
            }else{
                commentBottom.constant = 15
                closeButton.isHidden = true
            }
        }
    }
    
    @IBAction func sendButton(_ sender: Any) {
        guard let commentText = commentTextView.text else {return}
        viewModel.map{
            $0.saveComment(commentText: commentText) { [weak self] in
                guard let self = self else {return}
                switch $0{
                case .success:
                    DispatchQueue.main.async {
                        self.commentTextView.text = ""
                        self.commentTextView.endEditing(true)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.router.resultAlert(titleText: "コメントの保存に失敗", messageText: "もう一度送信してください", titleOK: "OK")
                    }
                }
            }
        }
    }
    
    @IBAction func closeKeyBoardButton(_ sender: Any) {
        commentTextView.endEditing(true)
    }
}

extension ProfileCommentListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        viewModel.map{
            count = $0.dataCount()
        }
        guard let count = count else {return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        viewModel.map{
            let data = $0.getData()[indexPath.row]
            cell.userCommentText.text = data.commentText
            guard let userObjectId = data.userObjectId else {return}
            $0.getUserData(userObjectId: userObjectId) { [weak self] in
                guard let self = self else {return}
                switch $0{
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.userNameLabel.text = data.userName
                    }
                    guard let fileName = data.iconImageFile else {return}
                    self.viewModel.map{
                        $0.getIconImage(fileName: fileName) {
                            switch $0 {
                            case .success(let imageData):
                                let uiImage = UIImage(data: imageData)
                                DispatchQueue.main.async {
                                    cell.iconImage.image = uiImage
                                }
                            case .failure:
                                return
                            }
                        }
                    }
                case .failure:
                    return
                }
            }
            guard let good = data.good else {return}
            if good {
                cell.goodButton.imageView?.image = UIImage(systemName: "star.fill")
            }else{
                cell.goodButton.imageView?.image = UIImage(systemName: "star")
            }
        }
        cell.goodButton.tag = indexPath.row
        cell.goodButton.addTarget(self, action: #selector(self.goodButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func goodButtonTapped(_ sender: UIButton) {
        viewModel.map{
            let data = $0.getData()[sender.tag]
            guard let good = data.good else {return}
            guard let objectId = data.objectId else {return}
            guard let commentUserObjectId = data.userObjectId else {return}
            let currentUserObjectId = $0.getCurrentUserObjectId()
            if currentUserObjectId == commentUserObjectId{
                router.resultAlert(titleText: "自分のコメントには押せません", messageText: "", titleOK: "OK")
            }else{
                if good {
                    $0.changeGoodValue(objectId: objectId, value: false) { [weak self] in
                        guard let self = self else {return}
                        switch $0 {
                        case .success:
                            DispatchQueue.main.async {
                                sender.setImage(UIImage(systemName: "star"), for: .normal)
                                self.viewModel.map{
                                    $0.changeTofalse(cellRow: sender.tag)
                                }
                            }
                        case .failure:
                            return
                        }
                    }
                }else{
                    $0.changeGoodValue(objectId: objectId, value: true) { [weak self] in
                        guard let self = self else {return}
                        switch $0 {
                        case .success:
                            self.viewModel.map{
                                $0.goodPush(userId: commentUserObjectId) {
                                    switch $0 {
                                    case .success:
                                        break
                                    case .failure:
                                        return
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
                                self.viewModel.map{
                                    $0.changeToTrue(cellRow: sender.tag)
                                }
                            }
                        case .failure:
                            return
                        }
                    }
                }
            }
        }
    }
}

extension ProfileCommentListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 70
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.map{
            router.transition(idetifier: "commentToProfile", sender: $0.getData()[indexPath.row].userObjectId)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let userId = sender as? String{
            let commentToProfile = segue.destination as! FollowUserProfileViewController
            commentToProfile.userObjectId = userId
        }
    }
}

extension ProfileCommentListViewController: AlertResult{
    func changeView() {
        router.popBackView()
    }
}
