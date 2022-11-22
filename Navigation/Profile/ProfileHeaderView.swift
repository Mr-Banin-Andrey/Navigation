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
        label.frame = CGRect(x: 130, y: 125, width: 150, height: 20)
        label.text = "Tурецкая чайка"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 16, y: 114, width: 100, height: 100)
        imageView.image = UIImage(named: "чайка")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 130, y: 170, width: 200, height: 20)
        label.text = "Здесь появятся мысли чайки"
        label.textColor = .gray
        return label
    }()
    
    private let showStatusButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 16, y: 245, width: 361, height: 50)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4781241417, blue: 0.9985476136, alpha: 1)
        button.setTitle("Показать мысли чайки", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 4
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        return button
    }()
    
    private let textStatusOfButton: UITextField = {
        let textStatus = UITextField()
        textStatus.frame = CGRect(x: 140, y: 205, width: 227, height: 30)
        textStatus.placeholder = "..."
        textStatus.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textStatus.backgroundColor = .white
        return textStatus
    }()
    
    private let viewTextStatus: UIView = {
        let viewText = UIView()
        viewText.frame = CGRect(x: 130, y: 200, width: 247, height: 40)
        viewText.layer.borderWidth = 1
        viewText.layer.borderColor = UIColor.black.cgColor
        viewText.layer.cornerRadius = 12
        viewText.backgroundColor = .white
        return viewText
    }()
    
    private var statusText: String = ""
    
    //MARK: - 2. Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameProfileLabel)
        addSubview(imageView)
        addSubview(statusLabel)
        addSubview(showStatusButton)
        addSubview(viewTextStatus)
        addSubview(textStatusOfButton)
        
        addTarget()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 3. Methods
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
