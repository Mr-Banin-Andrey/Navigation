

import UIKit

class FeedViewController: UIViewController {
   
    //MARK: - Properties
    private lazy var feedView = FeedView(delegate: self)
    
    private let viewModel: FeedViewModelProtocol
    
    //MARK: - init
    init(viewModel: FeedViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Life cycle
    override func loadView() {
        super.loadView()
        
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .secondarySystemBackground
        self.setupGestures()
        self.bindViewModel()
    }
       
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.didHideKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    //MARK: - Methods
    
    private func bindViewModel() {
        self.viewModel.onStateDidChange = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .initial:
                self.feedView.checkLabel.text = nil
                self.feedView.checkLabel.backgroundColor = nil
            case .checking:
                self.feedView.checkLabel.text = nil
                self.feedView.checkLabel.backgroundColor = nil
            case let .checked(check):
                self.feedView.checkLabel.text = check.text
                self.feedView.checkLabel.backgroundColor = UIColor(named: check.color)
            case let .error(error):
                switch error {
                case let .emptyValue(error):
                    self.feedView.checkLabel.text = error.text
                    self.feedView.checkLabel.backgroundColor = UIColor(named: error.color)
                case let .wrong(error):
                    self.feedView.checkLabel.text = error.text
                    self.feedView.checkLabel.backgroundColor = UIColor(named: error.color)
                }
            case .requestAuthorization:
                UserDefaults.standard.set(true, forKey: "requestAuthorization")
                self.feedView.registerNotificationButton.isHidden = true
                self.feedView.registerNotificationLabel.isHidden = true
            }
        }
    }
    
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
        guard let word = feedView.textCheck.text else { return }
        viewModel.updateState(viewInput: .guessWord(word: word))
    }
    
    func registerNotification() {
        viewModel.updateState(viewInput: .registerNotification)
    }
}
