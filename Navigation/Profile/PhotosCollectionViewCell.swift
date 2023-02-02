//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Андрей Банин on 27.12.22..
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    struct ViewModel {
        var photo: UIImage?
    }
    
    private lazy var photoImage: UIImageView = {
        let photo = UIImageView()
        photo.translatesAutoresizingMaskIntoConstraints = false
        return photo
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with viewModel: ViewModel) {
        self.photoImage.image = viewModel.photo
    }
    
    private func setupConstraints() {
        self.addSubview(self.photoImage)
        
        NSLayoutConstraint.activate([
            self.photoImage.topAnchor.constraint(equalTo: self.topAnchor),
            self.photoImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.photoImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.photoImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
