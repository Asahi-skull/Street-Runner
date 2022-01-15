//
//  UserProfileViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/12/18.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: UserProfileViewModel?
    private lazy var router: UserProfileRouter = UserProfileRouterImpl(viewController: self)
    var userObjectId: String?
    private var ncmbClass: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userObjectId = userObjectId {
            viewModel = UserProfileViewModelImpl(userObjectId: userObjectId)
        }else{
            router.resultAlert(titleText: "データの取得に失敗", messageText: "戻る", titleOK: "OK")
            navigationController?.popViewController(animated: true)
            return
        }
        viewModel.map{
            switch $0.checkFollow(){
            case .success:
                break
            case .failure:
                return
            }
        }
        let userNib = UINib(nibName: "UserProfileTableViewCell", bundle: nil)
        tableView.register(userNib, forCellReuseIdentifier: "userProfileCell")
        let segmentedNib = UINib(nibName: "SegmentedTableCell", bundle: nil)
        tableView.register(segmentedNib, forCellReuseIdentifier: "segmentedCell")
        let postedTableNib = UINib(nibName: "ProfilePostedTableViewCell", bundle: nil)
        tableView.register(postedTableNib, forCellReuseIdentifier: "profilePostedCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.map{
            $0.getRequestData{ [weak self] in
                guard let self = self else {return}
                switch $0{
                case .success:
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.ncmbClass = "request"
                case .failure:
                    DispatchQueue.main.async {
                        self.router.resultAlert(titleText: "データの取得に失敗", messageText: "再試行してください", titleOK: "OK")
                    }
                }
            }
        }
    }
}

extension UserProfileViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileCell", for: indexPath) as! UserProfileTableViewCell
            viewModel.map{
                let postedUserObjectId = $0.getUserObjectId()
                let currentUserObjectId = $0.getCurrentUserObjectId()
                if postedUserObjectId == currentUserObjectId {
                    cell.followButton.isEnabled = false
                }else{
                    cell.followButton.isEnabled = true
                }
                $0.getUserProfile { [weak self] in
                    guard let self = self else {return}
                    switch $0 {
                    case .success(let userData):
                        guard let userName = userData.userName else {return}
                        DispatchQueue.main.async {
                            cell.userNameLabel.text = userName
                        }
                        self.viewModel.map{
                            guard let iconImageFile = userData.iconImageFile else {return}
                            $0.setImage(fileName: iconImageFile) {
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
                if $0.boolcheck() {
                    cell.alreadyFollowUp()
                }else{
                    cell.notFollowUp()
                }
                $0.countFollower {
                    switch $0{
                    case .success(let int):
                        let count = String(int)
                        DispatchQueue.main.async {
                            cell.followerLabel.text = count
                        }
                    case .failure:
                        return
                    }
                }
                $0.countFollowing {
                    switch $0{
                    case .success(let int):
                        let count = String(int)
                        DispatchQueue.main.async {
                            cell.followingLabel.text = count
                        }
                    case .failure:
                        return
                    }
                }
            }
            cell.followButton.addTarget(self, action: #selector(self.followButtonTapped(_:)), for: .touchUpInside)
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "segmentedCell", for: indexPath) as! SegmentedTableCell
            cell.segmented.addTarget(self, action: #selector(self.segmentChanged(_:)), for: .valueChanged)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "profilePostedCell", for: indexPath) as! ProfilePostedTableViewCell
            cell.collectionView.reloadData()
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            return cell
        }
    }
    
    @objc func followButtonTapped(_ sender : UIButton) {
        viewModel.map{
            if $0.boolcheck(){
                $0.unFollow {
                    switch $0{
                    case .success:
                        DispatchQueue.main.async {
                            sender.backgroundColor = UIColor(named: "blueBack")
                            sender.setTitle("フォローする", for: .normal)
                            sender.setTitleColor(UIColor.white, for: .normal)
                        }
                    case .failure:
                        return
                    }
                }
            }else{
                $0.follow {
                    switch $0 {
                    case .success:
                        DispatchQueue.main.async {
                            sender.backgroundColor = UIColor(named: "whiteBack")
                            sender.layer.borderColor = UIColor(named: "blackBorder")?.cgColor
                            sender.layer.borderWidth = 1.0
                            sender.setTitle("フォロー中", for: .normal)
                            sender.setTitleColor(UIColor(named: "blackText"), for: .normal)
                        }
                    case .failure:
                        return
                    }
                }
            }
        }
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            viewModel.map{
                $0.getRequestData{ [weak self] in
                    guard let self = self else {return}
                    switch $0{
                    case .success:
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        self.ncmbClass = "request"
                    case .failure:
                        DispatchQueue.main.async {
                            self.router.resultAlert(titleText: "データの取得に失敗", messageText: "再試行してください", titleOK: "OK")
                        }
                    }
                }
            }
        case 1:
            viewModel.map{
                $0.getRecruitmentData{ [weak self] in
                    guard let self = self else {return}
                    switch $0{
                    case .success:
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        self.ncmbClass = "recruitment"
                    case .failure:
                        DispatchQueue.main.async {
                            self.router.resultAlert(titleText: "データの取得に失敗", messageText: "再試行してください", titleOK: "OK")
                        }
                    }
                }
            }
        default:
            break
        }
    }
}

extension UserProfileViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return tableView.bounds.height * 2/7
        }else if indexPath.row == 1{
            return tableView.bounds.height/18
        }else{
            return tableView.bounds.height - tableView.bounds.height/18
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int?
        viewModel.map{
            count = $0.dataCount()
        }
        guard let count = count else {return 0}
        return count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilePostedCollectionCell", for: indexPath) as! ProfilePostedCollectionViewCell
        viewModel.map{
            let data = $0.getData(indexPath: indexPath)
            guard let fileName = data.requestImage else {return}
            $0.setImage(fileName: fileName) {
                switch $0 {
                case .success(let imageData):
                    let uiImage = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        cell.postedImage.image = uiImage
                    }
                case .failure:
                    return
                }
            }
            guard let postedText = data.requestText else {return}
            cell.commentText.text = postedText
        }
        return cell
    }
}

extension UserProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.map{
            router.transition(idetifier: "toUserDetail", sender: $0.getData(indexPath:indexPath))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let entity = sender as? ProfilePostedEntity{
            let toUserDetail = segue.destination as! UserDetailViewController
            let data = detailData(objectID: entity.objectID, requestImage: entity.requestImage, requestText: entity.requestText, userObjectID: viewModel?.getUserObjectId(), className: ncmbClass)
            toUserDetail.entity = data
        }
    }
}

extension UserProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 5
        let cellSize: CGFloat = self.tableView.bounds.width/2 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize + cellSize/3)
    }
}
