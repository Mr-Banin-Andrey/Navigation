//
//  FeedViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 18.10.22..
//

import UIKit

class FeedViewController: UIViewController {
   
    //MARK: - Properties
    private lazy var feedView = FeedView(delegate: self)
    
    var viewModel: FeedViewModelProtocol! {
        didSet {
            self.viewModel.onStateDidChange = { [weak self] state in
                guard let self = self else {
                    return
                }
                switch state {
                case .initial:
                    self.feedView.checkLabel.text = nil
                    self.feedView.checkLabel.backgroundColor = nil
                case let .checking(check):
                    self.feedView.checkLabel.text = check.text
                    self.feedView.checkLabel.backgroundColor = check.color
                }
            }
        }
    }
    
    
    //MARK: - Life cycle
    override func loadView() {
        super.loadView()
        
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        self.setupGestures()
    }
       
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didHideKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //MARK: - Methods
    
    private func setupGestures() {
        let tapGestures = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGestures)
    }
    
    @objc private func didHideKeyboard(_ notification: Notification) {
        self.forcedHidingKeyboard()
    }
    
    @objc private func forcedHidingKeyboard() {
        self.view.endEditing(true)
    }
    
}


extension FeedViewController: FeedViewDelegate {    
    func showPostVCon() {
        viewModel.updateState(viewInput: .showPostVC)
    }
    
    func showInfoVCon() {
        viewModel.updateState(viewInput: .showInfoVC)
    }
    
    func guessWord() {
        viewModel.updateState(viewInput: .guessWord(word: feedView.textCheck.text!))
    }
}
