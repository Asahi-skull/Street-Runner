//
//  CommentListViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/18.
//

import UIKit

class CommentListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentBottom: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    
    var viewModel: CommentListViewModel?
    lazy var router: CommentListRouter = CommentListRouterImpl(viewController: self)
    
    var entity: commentData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let entity = entity {
            viewModel = CommentListViewModelImpl(entiry: entity)
        }else{
            router.resultAlert(titleText: "データの取得に失敗", messageText: "戻る", titleOK: "OK")
            navigationController?.popViewController(animated: true)
            return
        }
        viewModel.map{
            $0.getComment {
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
    
    @IBAction func sendButtton(_ sender: Any) {
        guard let commentText = commentTextView.text else {return}
        viewModel.map{
            $0.saveComment(commentText: commentText) {
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

extension CommentListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = viewModel?.dataCount() else {return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        guard let data = viewModel?.getData(indexPath: indexPath) else {return cell}
        cell.userCommentText.text = data.commentText
        viewModel.map{
            guard let userObjectId = data.userObjectId else {return}
            $0.getUserData(userObjectId: userObjectId) {
                switch $0{
                case .success(let datas):
                    DispatchQueue.main.async {
                        cell.userNameLabel.text = datas.userName
                    }
                    guard let fileName = datas.iconImageFile else {return}
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
//            let currentUserObjectId = $0.getCurrentUserObjectId()
//            let postedUserObjecId = $0.getObjectId().userObjectId
//            if userObjectId == currentUserObjectId {
//                if currentUserObjectId == postedUserObjecId{
//                    cell.goodButton.isEnabled = false
//                }else{
//                    cell.goodButton.isEnabled = true
//                }
//            }else{
//                cell.goodButton.isEnabled = false
//            }
        }
//        cell.goodButton.addTarget(self, action: #selector(self.goodButtonTapped(_:)), for: .touchUpInside)
        return cell
    }
    
//    @objc func goodButtonTapped(_ sender: UIButton) {
//    }
}

extension CommentListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 70
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
