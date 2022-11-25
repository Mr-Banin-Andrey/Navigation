//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Андрей Банин on 17.11.22..
//

import UIKit

class ProfileHeaderView: UIView {
    
    //MARK: - 1. Properties
    private let nameProfileLabel: UILabel = {
        let label = UILabel()
        label.text = "Tурецкая чайка"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "чайка")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Здесь появятся мысли чайки"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let showStatusButton: UIButton = {
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
    
    private let textStatusOfButton: UITextField = {
        let textStatus = UITextField()
        textStatus.placeholder = "..."
        textStatus.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textStatus.backgroundColor = .white
        textStatus.translatesAutoresizingMaskIntoConstraints = false
        return textStatus
    }()
    
    private let viewTextStatus: UIView = {
        let viewText = UIView()
        viewText.layer.borderWidth = 1
        viewText.layer.borderColor = UIColor.black.cgColor
        viewText.layer.cornerRadius = 12
        viewText.backgroundColor = .white
        viewText.translatesAutoresizingMaskIntoConstraints = false
        return viewText
    }()
    
    private var statusText: String = ""
    
    private let newButton: UIButton = {
        let newButton = UIButton()
        newButton.setTitle("какая-то кнопка", for: .normal)
        newButton.setTitleColor(UIColor.white, for: .normal)
        newButton.backgroundColor = #colorLiteral(red: 0, green: 0.4780646563, blue: 0.9985368848, alpha: 1)
        newButton.translatesAutoresizingMaskIntoConstraints = false
        return newButton
    }()
    
    //MARK: - 2. Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        addTarget()
        addTargets()
        setupConstraints()
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 3. Methods
    
    func setupConstraints() {
        addSubview(nameProfileLabel)
        addSubview(imageView)
        addSubview(statusLabel)
        addSubview(showStatusButton)
        addSubview(viewTextStatus)
        addSubview(textStatusOfButton)
        addSubview(newButton)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            nameProfileLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 14),
            nameProfileLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            statusLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 14),
            statusLabel.topAnchor.constraint(equalTo: nameProfileLabel.bottomAnchor, constant: 20),
            
            viewTextStatus.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 14),
            viewTextStatus.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            viewTextStatus.topAnchor.constraint(equalTo: nameProfileLabel.bottomAnchor, constant: 50),
            viewTextStatus.heightAnchor.constraint(equalToConstant: 40),
            
            textStatusOfButton.leadingAnchor.constraint(equalTo: viewTextStatus.leadingAnchor, constant: 10),
            textStatusOfButton.trailingAnchor.constraint(equalTo: viewTextStatus.trailingAnchor, constant: -10),
            textStatusOfButton.topAnchor.constraint(equalTo: viewTextStatus.topAnchor, constant: 5),
            textStatusOfButton.bottomAnchor.constraint(equalTo: viewTextStatus.bottomAnchor, constant: -5),
            
            showStatusButton.topAnchor.constraint(equalTo: viewTextStatus.bottomAnchor, constant: 15),
            showStatusButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            showStatusButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            showStatusButton.heightAnchor.constraint(equalToConstant: 50),
            
            newButton.heightAnchor.constraint(equalToConstant: 30),
            newButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            newButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            newButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
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
