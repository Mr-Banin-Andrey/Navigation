

import Foundation
import UIKit

@available(iOS 16.0, *)
class LikePostsViewController: UIViewController {
    
    var coordinator: LikePostsCoordinator?
    
    private lazy var likesPostView = LikePostsView(delegate: self)
    
    private let coreDataService: CoreDataService = CoreDataService()
    
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
        let corePosts = self.coreDataService.fenchPosts()
        self.likePosts = corePosts.map{ ProfilePost(likePostCoreDataModel: $0) }
        likesPostView.reload()
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
            
            let success = self.coreDataService.deletePost(predicate: NSPredicate(format: "idPost == %@", likePost.idPost))
            
            if success {
                self.likePosts.remove(at: indexPath.row)
                self.likesPostView.reload()
            }
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
                        
            let success = self.coreDataService.fenchPosts(
                predicate: NSPredicate(
                    format: "author == %@",
                    alert.textFields?.first?.text ?? ""))
            
            if success.isEmpty == false {
                self.likePosts = success.map{ ProfilePost(likePostCoreDataModel: $0) }
                self.likesPostView.reload()
            } else {
                ShowAlert().showAlert(vc: self, title: "Автора не существует или автор введен некорректно", message: "Попробовать ещё раз")
                self.likesPostView.leftButton.isHidden = true
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
