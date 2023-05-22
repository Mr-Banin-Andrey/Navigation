

import StorageService
import UIKit


class PostViewController: UIViewController {
    
    weak var coordinator: FeedCoordinator?
    
    //MARK: - 1. Properties
    var titleView = PostTitle(title: "Post")
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    //MARK: - 2. Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .cyan
        setupConstraints()
        titleLabel.text = titleView.title
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddTapped))
        navigationItem.rightBarButtonItems = [add]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddTapped))
    }
    
    //MARK: - 3. Methods
    func setupConstraints() {
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.firstBaselineAnchor, constant: 65),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func showAddTapped() {
        coordinator?.showInfoVC()
//        let addTapped = InfoViewController()
//        navigationController?.pushViewController(addTapped, animated: true)
    }
}
