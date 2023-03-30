//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Андрей Банин on 17.11.22..
//

import UIKit
import SnapKit

class ProfileHeaderView: UITableViewHeaderFooterView {
    
    //MARK: - 1. Properties
    private lazy var nameProfileLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var showStatusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4781241417, blue: 0.9985476136, alpha: 1)
        button.setTitle("Показать мысли чайки", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var textStatusOfButton: UITextField = {
        let textStatus = UITextField()
        textStatus.placeholder = "..."
        textStatus.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textStatus.backgroundColor = .white
        textStatus.translatesAutoresizingMaskIntoConstraints = false
        return textStatus
    }()
    
    private lazy var viewTextStatus: UIView = {
        let viewText = UIView()
        viewText.layer.borderWidth = 1
        viewText.layer.borderColor = UIColor.black.cgColor
        viewText.layer.cornerRadius = 12
        viewText.backgroundColor = .white
        viewText.translatesAutoresizingMaskIntoConstraints = false
        return viewText
    }()
    
    private var statusText: String = ""
    
    //MARK: - 2. Life cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
                
        self.addTarget()
        self.addTargets()
        self.setupConstraints()
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 3. Methods
    
    private func setupConstraints() {
        
        self.addSubview(self.nameProfileLabel)
        self.addSubview(self.imageView)
        self.addSubview(self.statusLabel)
        self.addSubview(self.showStatusButton)
        self.addSubview(self.viewTextStatus)
        self.addSubview(self.textStatusOfButton)
        
        self.imageView.snp.makeConstraints { maker in
            maker.width.equalTo(100)
            maker.height.equalTo(100)
            maker.top.equalToSuperview().inset(16)
            maker.left.equalToSuperview().inset(16)
        }
        self.nameProfileLabel.snp.makeConstraints { maker in
            maker.left.equalTo(self.imageView.snp.right).offset(14)
            maker.top.equalToSuperview().inset(27)
        }
        self.statusLabel.snp.makeConstraints { maker in
            maker.left.equalTo(self.imageView.snp.right).offset(14)
            maker.top.equalTo(self.nameProfileLabel.snp.bottom).offset(20)
        }
        self.viewTextStatus.snp.makeConstraints { maker in
            maker.left.equalTo(self.imageView.snp.right).offset(14)
            maker.right.equalToSuperview().inset(16)
            maker.top.equalTo(self.nameProfileLabel.snp.bottom).offset(50)
            maker.height.equalTo(40)
        }
        self.textStatusOfButton.snp.makeConstraints { maker in
            maker.left.right.equalTo(self.viewTextStatus).inset(10)
            maker.top.bottom.equalTo(self.viewTextStatus).inset(5)
        }
        self.showStatusButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.viewTextStatus.snp.bottom).offset(15)
            maker.left.right.equalToSuperview().inset(16)
            maker.height.equalTo(50)
            maker.bottom.equalToSuperview().inset(16)
        }
    }
    
    func setup(user: User) {
        nameProfileLabel.text = user.fullName
        imageView.image = user.userPhoto.userPhoto
        statusLabel.text = user.status
    }
    
    private func addTarget () {
        showStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    private func addTargets () {
        textStatusOfButton.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
    }
    
    @objc private func buttonPressed () {
        statusLabel.text = statusText
    }
    
    @objc private func statusTextChanged () {
        if textStatusOfButton.text != nil {
            statusText = textStatusOfButton.text!
        }
    }
    
}

extension String {
    var userPhoto: UIImage? { get { return UIImage(named: self) } }
}