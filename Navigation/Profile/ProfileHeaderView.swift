//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Андрей Банин on 17.11.22..
//

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {
    
    //MARK: - 1. Properties
    private lazy var nameProfileLabel: UILabel = {
        let label = UILabel()
        label.text = "Tурецкая чайка"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "чайка")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Здесь появятся мысли чайки"
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
                
        addTarget()
        addTargets()
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 3. Methods
    
    func setupConstraints() {
        
        self.addSubview(self.nameProfileLabel)
        self.addSubview(self.imageView)
        self.addSubview(self.statusLabel)
        self.addSubview(self.showStatusButton)
        self.addSubview(self.viewTextStatus)
        self.addSubview(self.textStatusOfButton)
        
        NSLayoutConstraint.activate([
            
            self.imageView.widthAnchor.constraint(equalToConstant: 100),
            self.imageView.heightAnchor.constraint(equalToConstant: 100),
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            self.nameProfileLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 14),
            self.nameProfileLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 27),
            
            self.statusLabel.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 14),
            self.statusLabel.topAnchor.constraint(equalTo: self.nameProfileLabel.bottomAnchor, constant: 20),
            
            self.viewTextStatus.leadingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: 14),
            self.viewTextStatus.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.viewTextStatus.topAnchor.constraint(equalTo: self.nameProfileLabel.bottomAnchor, constant: 50),
            self.viewTextStatus.heightAnchor.constraint(equalToConstant: 40),
            
            self.textStatusOfButton.leadingAnchor.constraint(equalTo: self.viewTextStatus.leadingAnchor, constant: 10),
            self.textStatusOfButton.trailingAnchor.constraint(equalTo: self.viewTextStatus.trailingAnchor, constant: -10),
            self.textStatusOfButton.topAnchor.constraint(equalTo: self.viewTextStatus.topAnchor, constant: 5),
            self.textStatusOfButton.bottomAnchor.constraint(equalTo: self.viewTextStatus.bottomAnchor, constant: -5),
        
            self.showStatusButton.topAnchor.constraint(equalTo: self.viewTextStatus.bottomAnchor, constant: 15),
            self.showStatusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.showStatusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.showStatusButton.heightAnchor.constraint(equalToConstant: 50),
            self.showStatusButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    func addTarget () {
        showStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    func addTargets () {
        textStatusOfButton.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
    }
    
    @objc func buttonPressed () {
        statusLabel.text = statusText
    }
    
    @objc func statusTextChanged () {
        if textStatusOfButton.text != nil {
            statusText = textStatusOfButton.text!
        }
    }
}
