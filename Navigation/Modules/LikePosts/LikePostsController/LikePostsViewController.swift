

import Foundation
import UIKit

@available(iOS 15.0, *)
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
        self.likesPostView.navigationController(navigation: navigationItem, title: "Like Posts")
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

@available(iOS 15.0, *)
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
    
}

@available(iOS 15.0, *)
extension LikePostsViewController: LikePostsViewDelegate {
    
}
