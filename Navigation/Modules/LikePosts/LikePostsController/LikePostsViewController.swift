

import Foundation
import UIKit

@available(iOS 16.0, *)
class LikePostsViewController: UIViewController {
    
    var coordinator: LikePostsCoordinator?
    
    private lazy var likesPostView = LikePostsView(delegate: self)
    
    private let coreDataService: CoreDataService = CoreDataService.shared
    
    private var likePosts = [ProfilePost]()
    
    override func loadView() {
        super.loadView()
        
        view = likesPostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.likesPostView.configurationTableView(dataSourse: self,
                                                  delegate: self)
        self.likesPostView.navigationController(title: "Like Posts",
                                                navigation: navigationItem,
                                                rightButton: likesPostView.rightButton,
                                                leftButton: likesPostView.leftButton)
        self.fetchPosts()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(postAdded),
                                               name: NSNotification.Name("postAdded"),
                                               object: nil)
    }
    
    func fetchPosts() {
        
        self.coreDataService.fetch(LikePostCoreDataModel.self, predicate: nil) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedObjects):
                self.likePosts = fetchedObjects.map({ ProfilePost(likePostCoreDataModel: $0)})
                likesPostView.reload()
            case .failure:
                fatalError()
            }
        }
    }
    
    @objc private func postAdded() {
        fetchPosts()
    }
}

@available(iOS 16.0, *)
extension LikePostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likePosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableId", for: indexPath) as? PostCustomTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultId", for: indexPath)
            return cell
        }
        
        cell.selectionStyle = .none
        let post = likePosts[indexPath.row]
        cell.setup(with: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            
            let likePost = self.likePosts[indexPath.row]
            
            self.coreDataService.deletePost(predicate: NSPredicate(format: "idPost == %@", likePost.idPost))
            self.likePosts.remove(at: indexPath.row)
            self.likesPostView.reload()
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

@available(iOS 16.0, *)
extension LikePostsViewController: LikePostsViewDelegate {
    
    func filterPosts() {
        
        let alert = UIAlertController(title: "Фильтр по автору", message: nil, preferredStyle: .alert)

        let createAction =  UIAlertAction(title: "Применить", style: .default) { _ in
                        
            self.coreDataService.fetch(
                LikePostCoreDataModel.self,
                predicate: NSPredicate(format: "author == %@", alert.textFields?.first?.text ?? "")
            ) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let fetchedObjects):
                    if fetchedObjects.isEmpty == false {
                        self.likePosts = fetchedObjects.map({ ProfilePost(likePostCoreDataModel: $0)})
                        likesPostView.reload()
                    } else {
                        ShowAlert().showAlert(vc: self, title: "Ошибка", message: "Автора не существует или автор введен некорректно", titleButton: "Попробовать ещё раз")
                        self.likesPostView.leftButton.isHidden = true
                    }
                case .failure:
                    fatalError()
                }
            }
        }
        
        likesPostView.alert(vc: self, alert: alert, createAction: createAction)
        self.likesPostView.leftButton.isHidden = false
    }
    
    func cancelFilter() {
        fetchPosts()
        likesPostView.leftButton.isHidden = true
    }
}
