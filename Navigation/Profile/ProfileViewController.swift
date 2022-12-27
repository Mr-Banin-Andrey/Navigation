//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 18.10.22..
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - 1. Properties
    
    private var posts: [PostCustomTableViewCell.ViewModel] = [
        PostCustomTableViewCell.ViewModel(author: "кожаный бастард", description: "задумалась", image: UIImage(named: "задумалась"), likes: 1, views: 456),
        PostCustomTableViewCell.ViewModel(author: "кожаный бастард", description: "моя авка", image: UIImage(named: "моя авка"), likes: 123, views: 599000),
        PostCustomTableViewCell.ViewModel(author: "кожаный бастард", description: "Обо мне: Ча́йки — наиболее многочисленный род птиц семейства чайковых, обитающих как на морских просторах, так и на внутренних водоёмах. Многие виды считаются синантропными — они живут вблизи человека и получают от этого выгоду.", image: UIImage(named: "я во всей красе"), likes: 2, views: 102),
        PostCustomTableViewCell.ViewModel(author: "кожаный бастард", description: "я с каким-то голубем", image: UIImage(named: "я с каким-то голубем"), likes: 55, views: 240)
    ]
    
    private var photoBooks: [PhotosTableViewCell.ViewModel] = [
        PhotosTableViewCell.ViewModel(imageOne: UIImage(named: "1"), imageTwo: UIImage(named: "2"), imageThree: UIImage(named: "3"), imageFour: UIImage(named: "4"))
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "headerId")
        tableView.register(PostCustomTableViewCell.self, forCellReuseIdentifier: "tableId")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "photosId")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultId")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - 2. Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        self.viewSetupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - 3. Methods
    private func viewSetupConstraints() {
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    @objc func showPhotosViewController() {
        let showPhotosViewController = PhotosViewController()
        navigationController?.pushViewController(showPhotosViewController, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") is ProfileHeaderView else { return nil }
            return ProfileHeaderView()
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if section == 0 {
           return 1
        }
        
        if section == 1 {
            let postsArrive = (self.posts.count)
            return postsArrive
        }

        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "photosId", for: indexPath) as? PhotosTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultId", for: indexPath)
                return cell
            }

            cell.selectionStyle = .none
            let photo = self.photoBooks[indexPath.row]
            cell.setup(with: photo)
            return cell
        }

        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableId", for: indexPath) as? PostCustomTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultId", for: indexPath)
                return cell
            }
            
            cell.selectionStyle = .none
            let post = self.posts[indexPath.row]
            cell.setup(with: post)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultId", for: indexPath)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            showPhotosViewController()
            
        }
    }
}
