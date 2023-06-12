

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
    }
    
    func fetchPosts() {
        let corePosts = self.coreDataService.fenchPosts()
        self.likePosts = corePosts.map{ ProfilePost(likePostCoreDataModel: $0) }
        
        
    }
}

@available(iOS 15.0, *)
extension LikePostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

@available(iOS 15.0, *)
extension LikePostsViewController: LikePostsViewDelegate {
    
}
