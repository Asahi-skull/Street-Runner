//
//  ProfileViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    private lazy var router: PerformAlertRouter = PerformAlertRouterImpl(viewController: self)
    private let profileViewModel: ProfileViewModel = ProfileViewModelImpl()
    private var className: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profileNib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        table.register(profileNib, forCellReuseIdentifier: "profileCell")
        let segmentedNib = UINib(nibName: "SegmentedTableCell", bundle: nil)
        table.register(segmentedNib, forCellReuseIdentifier: "segmentedCell")
        let postedTableNib = UINib(nibName: "ProfilePostedTableViewCell", bundle: nil)
        table.register(postedTableNib, forCellReuseIdentifier: "profilePostedCell")
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileViewModel.getRequest { [weak self] in
            guard let self = self else {return}
            switch $0{
            case .success:
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
                self.className = "request"
            case .failure:
                    self.router.resultAlert(titleText: "読み込みに失敗", messageText: "再試行してください", titleOK: "OK")
                return
            }
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        router.transition(idetifier: "toEdit",sender: nil)
    }
}

extension ProfileViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
            profileViewModel.getIconImage {
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
            cell.userNameLabel.text = profileViewModel.setUser()
            profileViewModel.countFollower {
                switch $0 {
                case .success(let int):
                    let count = String(int)
                    DispatchQueue.main.async {
                        cell.followerLabel.text = count
                    }
                case .failure:
                    return
                }
            }
            profileViewModel.countFollowing {
                switch $0 {
                case .success(let int):
                    let count = String(int)
                    DispatchQueue.main.async {
                        cell.followingLabel.text = count
                    }
                case .failure:
                    return
                }
            }
            profileViewModel.countGoodNumber {
                switch $0{
                case  .success(let count):
                    let count = String(count)
                    DispatchQueue.main.async {
                        cell.goodNumberLabel.text = count
                    }
                case .failure:
                    return
                }
            }
            cell.detailFollowButton.addTarget(self, action: #selector(self.detailFollowButtonTapped(_:)), for: .touchUpInside)
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
    
    @objc func detailFollowButtonTapped(_ sender: UIButton) {
        router.transition(idetifier: "toFollow", sender: nil)
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            profileViewModel.getRequest { [weak self] in
                guard let self = self else {return}
                switch $0 {
                case.success:
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                    self.className = "request"
                case .failure:
                    DispatchQueue.main.async{
                        self.router.resultAlert(titleText: "読み込みに失敗", messageText: "再試行してください", titleOK: "OK")
                    }
                }
            }
        case 1:
            profileViewModel.getRecruitmentData { [weak self] in
                guard let self = self else {return}
                switch $0 {
                case.success:
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                    self.className = "recruitment"
                case .failure:
                    DispatchQueue.main.async{
                        self.router.resultAlert(titleText: "読み込みに失敗", messageText: "再試行してください", titleOK: "OK")
                    }
                }
            }
        default:
            break
        }
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return tableView.bounds.height/6
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

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        profileViewModel.dataCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilePostedCollectionCell", for: indexPath) as! ProfilePostedCollectionViewCell
        let data = profileViewModel.getData(indexPath: indexPath)
        guard let requestImage = data.requestImage else {return cell}
        profileViewModel.getImage(fileName: requestImage) {
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
        guard let requestText = data.requestText else {return cell}
        cell.commentText.text = requestText
        return cell
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router.transition(idetifier: "profileToDetail", sender: profileViewModel.getData(indexPath:indexPath))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileToDetail"{
            if let data = sender as? ProfilePostedEntity {
                let profileToDetail = segue.destination as! ProfileDetailViewController
                let detailData = ProfileDetailData(objectID: data.objectID, requestImage: data.requestImage, requestText: data.requestText, className: className)
                profileToDetail.entity = detailData
            }
        }
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 5
        let cellSize: CGFloat = self.table.bounds.width/2 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize + cellSize/3)
    }
}
