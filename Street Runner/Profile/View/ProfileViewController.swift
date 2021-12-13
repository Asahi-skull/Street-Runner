//
//  ProfileViewController.swift
//  Street Runner
//
//  Created by 木本朝陽 on 2021/11/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    lazy var router: ProfileRouter = ProfileRouterImpl(viewController: self)
    let profileViewModel: ProfileViewModel = ProfileViewModelImpl()
    
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
        let iconResult = profileViewModel.getRequest()
        switch iconResult{
        case .success:
            table.reloadData()
        case .failure:
            return
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        router.transition(idetifier: "toEdit")
    }
}

extension ProfileViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileTableViewCell
           let result = profileViewModel.getIconImage()
            switch result{
            case .success(let uiImage):
                cell.iconImage.image = uiImage
            case .failure:
                return cell
            }
            cell.userNameLabel.text = profileViewModel.setUser()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return tableView.bounds.height/6
        }else if indexPath.row == 1{
            return tableView.bounds.height/18
        }else{
            return tableView.bounds.height - tableView.bounds.height/6 - tableView.bounds.height/18
        }
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            let result = profileViewModel.getRequest()
            switch result{
            case.success:
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            case .failure:
                router.resultAlert(titleText: "読み込みに失敗", messageText: "再試行してください", titleOK: "OK")
            }
        case 1:
            let result = profileViewModel.getRecruitmentData()
            switch result{
            case.success:
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            case .failure:
                router.resultAlert(titleText: "読み込みに失敗", messageText: "再試行してください", titleOK: "OK")
            }
        default:
            break
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let int = profileViewModel.dataCount()
        print(int)
        return int
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilePostedCollectionCell", for: indexPath) as! ProfilePostedCollectionViewCell
        let data = profileViewModel.getData(indexPath: indexPath)
        guard let requestImage = data.requestImage else {return cell}
        profileViewModel.getImage(fileName: requestImage, imageView: cell.postedImage)
        guard let requestText = data.requestText else {return cell}
        cell.commentText.text = requestText
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 5
        let cellSize: CGFloat = self.table.bounds.width/2 - horizontalSpace
        return CGSize(width: cellSize, height: cellSize + cellSize/3)
    }
}
