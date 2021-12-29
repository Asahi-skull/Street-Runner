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
        viewModel?.getComment(completion: { result in
            switch result{
            case .success:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure:
                DispatchQueue.main.async {
                    self.router.resultAlert(titleText: "データの取得に失敗", messageText: "再試行してください", titleOK: "OK")
                }
            }
        })
        tabBarController?.tabBar.isHidden = true
        let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "commentCell")
        commentTextView.layer.borderColor = UIColor.black.cgColor
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.cornerRadius = 10.0
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if commentBottom.constant == 15{
                commentBottom.constant = keyboardSize.height - 30
            }else{
                commentBottom.constant = 15
            }
        }
    }
    
    @IBAction func sendButtton(_ sender: Any) {
        guard let commentText = commentTextView.text else {return}
        viewModel?.saveComment(commentText: commentText, completion: { result in
            switch result{
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
        })
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
        viewModel?.getUserData(completion: { result in
            switch result{
            case .success(let datas):
                DispatchQueue.main.async {
                    cell.userNameLabel.text = datas.userName
                }
                guard let fileName = datas.iconImageFile else {return}
                self.viewModel?.getIconImage(fileName: fileName, imageView: cell.iconImage)
            case .failure:
                return
            }
        })
        return cell
    }
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
