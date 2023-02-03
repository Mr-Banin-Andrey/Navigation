//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 18.10.22..
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - 1. Properties
    
    let profileHV = ProfileHeaderView()
    
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
    
    private lazy var imageViewBig: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = profileHV.imageView.image
        image.isHidden = true
        image.clipsToBounds = true
        image.layer.cornerRadius = 50
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
    private lazy var viewBlur: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .black
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var closeImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.closeImageView), for: .touchUpInside)
        button.setImage(.init(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.isHidden = true
        return button
    }()
    
    private var imageWidthConstaint: NSLayoutConstraint?
    private var imageHeightConstaint: NSLayoutConstraint?
    
    private var isImageViewBigIncreased = false
    
    //MARK: - 2. Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        self.viewSetupConstraints()
        
        #if DEBUG
            self.view.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        #else
            self.view.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - 3. Methods
    private func viewSetupConstraints() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.viewBlur)
        self.view.addSubview(self.imageViewBig)
        self.view.addSubview(self.closeImageButton)
        
        self.imageWidthConstaint = self.imageViewBig.widthAnchor.constraint(equalToConstant: 100)
        self.imageHeightConstaint = self.imageViewBig.heightAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.viewBlur.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.viewBlur.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.viewBlur.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.viewBlur.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.closeImageButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.closeImageButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.imageWidthConstaint,
            self.imageHeightConstaint,
            self.imageViewBig.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.imageViewBig.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16)
        ].compactMap({ $0 }))
    }
    
    private func layoutZoomImage(completion: @escaping () -> Void) {
        self.imageWidthConstaint?.constant = self.isImageViewBigIncreased ? 100 : self.view.bounds.width
        self.imageHeightConstaint?.constant = self.isImageViewBigIncreased ? 100 : self.view.bounds.width
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
            self.viewBlur.alpha = 0.8
            self.imageViewBig.center = self.view.center
            self.viewBlur.isHidden = false
            self.imageViewBig.isHidden = false
        } completion: { _ in
            completion()
            self.closeImageButton.isHidden = false
        }
    }
    
    private func animateCloseView(completion: @escaping () -> Void) {
        self.imageWidthConstaint?.constant = self.isImageViewBigIncreased ? self.view.bounds.width : 100
        self.imageHeightConstaint?.constant = self.isImageViewBigIncreased ? self.view.bounds.width : 100

        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            self.imageViewBig.frame.origin.x = CGFloat(0)
            self.imageViewBig.frame.origin.y = CGFloat(0)
            self.view.layoutIfNeeded()
            self.closeImageButton.isHidden = true
            self.viewBlur.alpha = 0.0
        } completion: { _ in
            completion()
            self.imageViewBig.isHidden = true
            self.viewBlur.isHidden = true
            self.tableView.isUserInteractionEnabled = true
        }
    }
    
    
    @objc func zoomPicture(_ gestureRecognizer: UITapGestureRecognizer) {

        self.tableView.isUserInteractionEnabled = false // делает таблицу неактивной
        
        let abs1 = self.view.safeAreaLayoutGuide.layoutFrame.origin.y
        tableView.setContentOffset(CGPoint(x: 0, y: -abs1), animated: true)

        let completion: () -> Void = { [weak self] in
            self?.tableView.isUserInteractionEnabled = true
        }
        self.layoutZoomImage(completion: completion)
    }
    
    @objc func closeImageView() {
        let completion: () -> Void = { [weak self] in
            self?.tableView.isUserInteractionEnabled = true
        }
        self.animateCloseView(completion: completion)
    }
    
    @objc func showPhotosViewController() {
        let showPhotosViewController = PhotosViewController()
        navigationController?.pushViewController(showPhotosViewController, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as? ProfileHeaderView else { return nil }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.zoomPicture(_:)))
            header.imageView.addGestureRecognizer(tapGestureRecognizer)

            return header
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
