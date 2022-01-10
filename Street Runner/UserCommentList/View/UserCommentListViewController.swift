//
//  UserCommentListViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2022/01/09.
//

import UIKit

class UserCommentListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentBottom: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    
    var viewModel: UserCommentListViewModel?
    lazy var router: UserCommentListRouter = UserCommentListRouterImpl(viewController: self)
    
    var entity: commentData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let entity = entity {
            viewModel = UserCommentListViewModelImpl(entiry: entity)
        }else{
            router.resultAlert(titleText: "データの取得に失敗", messageText: "戻る", titleOK: "OK")
            navigationController?.popViewController(animated: true)
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
                commentBottom.constant = keyboardSize.height - 20
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
    
    @IBAction func closeAct(_ sender: Any) {
        commentTextView.endEditing(true)
    }
}

extension UserCommentListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.dataCount() else {return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        guard let data = viewModel?.getData()[indexPath.row] else {return cell}
        cell.userCommentText.text = data.commentText
        viewModel.map{
            guard let userObjectId = data.userObjectId else {return}
            $0.getUserData(userObjectId: userObjectId) { [weak self] in
                guard let self = self else {return}
                switch $0{
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.userNameLabel.text = data.userName
                    }
                    guard let fileName = data.iconImageFile else {return}
                    self.viewModel?.getIconImage(fileName: fileName, imageView: cell.iconImage)
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
        guard let data = viewModel?.getData()[sender.tag] else {return}
        guard let good = data.good else {return}
        guard let objectId = data.objectId else {return}
        guard let commentUserObjectId = data.userObjectId else {return}
        let currentUserObjectId = viewModel?.getCurrentUserObjectId()
        let postedUserObjectId = viewModel?.getObjectId().userObjectId
        if postedUserObjectId == currentUserObjectId {
            if currentUserObjectId == commentUserObjectId{
                router.resultAlert(titleText: "自分のコメントには押せません", messageText: "", titleOK: "OK")
            }else{
                if good {
                    viewModel?.changeGoodValue(objectId: objectId, value: false) { [weak self] in
                        guard let self = self else {return}
                        switch $0 {
                        case .success:
                            DispatchQueue.main.async {
                                sender.setImage(UIImage(systemName: "star"), for: .normal)
                                self.viewModel?.changeTofalse(cellRow: sender.tag)
                            }
                        case .failure:
                            return
                        }
                    }
                }else{
                    viewModel?.changeGoodValue(objectId: objectId, value: true) { [weak self] in
                        guard let self = self else {return}
                        switch $0 {
                        case .success:
                            DispatchQueue.main.async {
                                sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
                                self.viewModel?.changeToTrue(cellRow: sender.tag)
                            }
                        case .failure:
                            return
                        }
                    }
                }
            }
        }else{
            router.resultAlert(titleText: "投稿者しか押せません", messageText: "", titleOK: "OK")
        }
    }
}

extension UserCommentListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 70
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
