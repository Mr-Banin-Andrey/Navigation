//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 26.12.22..
//

import UIKit

class PhotosViewController: UIViewController {
    
    private enum Constants {
        static let numberOfItemsInLine: CGFloat = 3
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "customCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "defaultID")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var photoGallery: [PhotosCollectionViewCell.ViewModel] = [
        PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "1")), PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "2")),
        PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "3")), PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "4")),
        PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "5")), PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "6")),
        PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "7")), PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "8")),
        PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "9")), PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "10")),
        PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "11")), PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "12")),
        PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "13")), PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "14")),
        PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "15")), PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "16")),
        PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "17")), PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "18")),
        PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "19")), PhotosCollectionViewCell.ViewModel(photo: UIImage(named: "20"))
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBarFunc()
        self.setupConstraints()
    }
    
    private func navigationBarFunc() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Photo Gallery"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupConstraints() {
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.photoGallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as? PhotosCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultID", for: indexPath)
            return cell
        }
        
        cell.setup(with: self.photoGallery[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let insert = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let interItemSpacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
        
        let wight = collectionView.frame.width - (Constants.numberOfItemsInLine - 1) * interItemSpacing - insert.left - insert.right
        let itemWight = floor(wight / Constants.numberOfItemsInLine)
        
        return CGSize(width: itemWight, height: itemWight)
    }
}
