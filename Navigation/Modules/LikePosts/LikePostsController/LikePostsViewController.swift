

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
        self.likesPostView.navigationController(title: "viewController.title.likePosts".localized,
                                                navigation: navigationItem,
                                                rightButton: likesPostView.rightButton,
                                                leftButton: likesPostView.leftButton)
        
        self.coreDataService.fetchResultsController()
        self.coreDataService.fetchedResultsController?.delegate = self
        self.coreDataService.performFetch()
    }
}

@available(iOS 16.0, *)
extension LikePostsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.coreDataService.fetchedResultsController?.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableId", for: indexPath) as? PostCustomTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "defaultId", for: indexPath)
            return cell
        }
        guard
            let post = self.coreDataService.fetchedResultsController?.object(at: indexPath)
        else { return cell }
        
        cell.setupModel(with: post)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "likePostsVC.tableView.swipe.action.title".localized
        ) { _, _, _ in

            guard
                let context = self.coreDataService.context,
                let post = self.coreDataService.fetchedResultsController?.object(at: indexPath)
            else { return }
                    
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
        
        let alert = UIAlertController(
            title: "likePostsVC.alertController.title".localized,
            message: nil,
            preferredStyle: .alert
        )
        let createAction =  UIAlertAction(
            title: "likePostsVC.action.createAction.title".localized,
            style: .default
        ) { _ in
            
            let author = alert.textFields?.first?.text ?? ""

            self.coreDataService.searchFetchResultsController(author: author)
            self.coreDataService.performFetch()
            self.likesPostView.reload()
        }
        
        likesPostView.alert(vc: self, alert: alert, createAction: createAction)
        self.likesPostView.leftButton.isHidden = false
    }

    func cancelFilter() {
        self.coreDataService.fetchResultsController()
        self.coreDataService.performFetch()
        self.likesPostView.reload()
        self.likesPostView.leftButton.isHidden = true
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
