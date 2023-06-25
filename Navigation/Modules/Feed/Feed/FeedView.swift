

import Foundation
import UIKit


protocol FeedViewDelegate: AnyObject {
    func showPostVCon()
    func showInfoVCon()
    func guessWord()
}


class FeedView: UIView {
    
    var tapAction: (() -> Void)?
    
    private weak var delegate: FeedViewDelegate?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Feed"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var twoButtons: UIStackView = {
        let twoButtons = UIStackView()
        twoButtons.axis = .vertical
        twoButtons.spacing = 10
        twoButtons.translatesAutoresizingMaskIntoConstraints = false
        return twoButtons
    }()
    
    private lazy var firstButton: CustomButton = {
        let button = CustomButton(title: "Show Post", bgColor: #colorLiteral(red: 0.042927064, green: 0.5177074075, blue: 1, alpha: 1)) { [unowned self] in
            delegate?.showPostVCon()
            tapAction?()
        }
        return button
    }()
    
    private lazy var secondButton: CustomButton = {
        let button = CustomButton(title: "Show Info", bgColor: #colorLiteral(red: 0.042927064, green: 0.5177074075, blue: 1, alpha: 1)) { [unowned self] in
            delegate?.showInfoVCon()
            tapAction?()
        }
        return button
    }()
    
    lazy var textCheck: UITextField = {
        let textStatus = UITextField()
        textStatus.placeholder = " Text Check "
        textStatus.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textStatus.backgroundColor = .white
        textStatus.translatesAutoresizingMaskIntoConstraints = false
        return textStatus
    }()
    
    private lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(title: "Check guess", bgColor: .blue) { [unowned self] in
            delegate?.guessWord()
            tapAction?()
        }
        return button
    }()
    
    lazy var checkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(delegate: FeedViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.backgroundColor = .lightGray
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupConstraints(){
        self.addSubview(label)
        self.addSubview(twoButtons)
        twoButtons.addArrangedSubview(firstButton)
        twoButtons.addArrangedSubview(secondButton)
        self.addSubview(self.textCheck)
        self.addSubview(self.checkGuessButton)
        self.addSubview(self.checkLabel)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 65),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            twoButtons.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            twoButtons.centerYAnchor.constraint(equalTo: self.topAnchor, constant: 150),
            
            textCheck.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            textCheck.topAnchor.constraint(equalTo: twoButtons.bottomAnchor, constant: 200),
            textCheck.widthAnchor.constraint(equalToConstant: 150),
            textCheck.heightAnchor.constraint(equalToConstant: 30),
            
            checkGuessButton.topAnchor.constraint(equalTo: textCheck.bottomAnchor, constant: 25),
            checkGuessButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            checkLabel.topAnchor.constraint(equalTo: twoButtons.bottomAnchor, constant: 150),
            checkLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            checkLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}


