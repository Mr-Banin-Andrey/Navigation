

import Foundation
import UIKit
import CoreData

@available(iOS 16.0, *)
class LikePostsViewController: UIViewController {
    
    var coordinator: LikePostsCoordinator?
    
    private lazy var likesPostView = LikePostsView(delegate: self)
    
    private let coreDataService: CoreDataServiceFetchResult = CoreDataServiceFetchResult()
    
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
        
        self.coreDataService.fetchedResultsController.delegate = self
        

        self.coreDataService.fetchLikePosts()
    }
}

@available(iOS 16.0, *)
extension LikePostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.coreDataService.fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableId", for: indexPath) as? PostCustomTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultId", for: indexPath)
            return cell
        }
        
        let post = self.coreDataService.fetchedResultsController.object(at: indexPath)
        
        cell.setupModel(with: post)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in

            guard let context = self.coreDataService.context else { return }
            let post = self.coreDataService.fetchedResultsController.object(at: indexPath)
            
            context.delete(post)
                
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

@available(iOS 16.0, *)
extension LikePostsViewController: LikePostsViewDelegate {

    func filterPosts() {
        
//        let posts = self.coreDataService.fetchedResultsController?.fetchedObjects
//        print("post", posts)
//        posts?.forEach({ value in
//            value.author
//        })
//        guard let context = self.coreDataService.context else { return print("❌ 5") }
//        let posts = Posts().postsArray
//        addPost(post: posts[1], context: context)
//        addPost(post: posts[3], context: context)
//        addPost(profilePost: posts[2])
//        addPost(profilePost: posts[3])

//        let alert = UIAlertController(title: "Фильтр по автору", message: nil, preferredStyle: .alert)
//
//        let createAction =  UIAlertAction(title: "Применить", style: .default) { _ in
//
//            self.coreDataService.fetch(
//                LikePostCoreDataModel.self,
//                predicate: NSPredicate(format: "author == %@", alert.textFields?.first?.text ?? "")
//            ) { [weak self] result in
//                guard let self = self else { return }
//
//                switch result {
//                case .success(let fetchedObjects):
//                    if fetchedObjects.isEmpty == false {
//                        self.likePosts = fetchedObjects.map({ ProfilePost(likePostCoreDataModel: $0)})
//                        likesPostView.reload()
//                    } else {
//                        ShowAlert().showAlert(vc: self, title: "Ошибка", message: "Автора не существует или автор введен некорректно", titleButton: "Попробовать ещё раз")
//                        self.likesPostView.leftButton.isHidden = true
//                    }
//                case .failure:
//                    fatalError()
//                }
//            }
//        }
//
//        likesPostView.alert(vc: self, alert: alert, createAction: createAction)
//        self.likesPostView.leftButton.isHidden = false
    }

    func cancelFilter() {
//        fetchPosts()
//        likesPostView.leftButton.isHidden = true
    }
}


@available(iOS 16.0, *)
extension LikePostsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.likesPostView.tableView.beginUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            self.likesPostView.tableView.insertRows(at: [newIndexPath], with: .left)
        case .delete:
            guard let indexPath = indexPath else { return }
            self.likesPostView.tableView.deleteRows(at: [indexPath], with: .right)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            self.likesPostView.tableView.deleteRows(at: [indexPath], with: .right)
            self.likesPostView.tableView.insertRows(at: [newIndexPath], with: .left)
        case .update:
            guard let indexPath = indexPath else { return }
            self.likesPostView.tableView.reloadRows(at: [indexPath], with: .fade)
        @unknown default:
            fatalError()
        }
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.likesPostView.tableView.endUpdates()
    }
}
