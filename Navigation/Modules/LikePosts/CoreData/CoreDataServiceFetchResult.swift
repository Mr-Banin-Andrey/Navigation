//
//  CoreDataServiceFetchResult.swift
//  Navigation
//
//  Created by Андрей Банин on 17.6.23..
//

import CoreData
import UIKit

@available(iOS 15.0, *)
protocol CoreDataServiceFetchResultDelegate {
    func addPost(_ profilePost: ProfilePost) -> Bool
    
}

@available(iOS 15.0, *)
final class CoreDataServiceFetchResult {
    
    var context: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<LikePostCoreDataModel>?
    

    func fetchResultsController() {
        self.context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        guard let context = self.context else { fatalError() }
        
        let fetchRequest = LikePostCoreDataModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "author", ascending: true)
        fetchRequest.sortDescriptors = [
            sortDescriptor
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }
    
    func searchFetchResultsController(author: String) {
        self.context = (UIApplication.shared.delegate as?  AppDelegate)?.persistentContainer.viewContext
        
        guard let context = self.context else { fatalError() }
        
        let predicate = NSPredicate(format: "author == %@", author)
        let fetchRequest = LikePostCoreDataModel.fetchRequest()
        
        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "author", ascending: true)
        fetchRequest.sortDescriptors = [
            sortDescriptor
        ]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }
    
    func performFetch() {
        guard let fetchedResultsController = fetchedResultsController else { return }
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Can't fetch data from db")
        }
    }
    
    func addPostToLikePosts(_ profilePost: ProfilePost) -> Bool {
        
        guard
            let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        else { return false }
        
        let postModel = LikePostCoreDataModel(context: context)
        postModel.idPost = profilePost.idPost
        postModel.author = profilePost.author
        postModel.descriptionPost = profilePost.description
        postModel.photoPost = profilePost.photoPost
        postModel.likes = Int64(profilePost.likes)
        postModel.views = Int64(profilePost.views)
        return true
    }
}
    
@available(iOS 15.0, *)
extension CoreDataServiceFetchResult: CoreDataServiceFetchResultDelegate {
    
    func addPost(_ profilePost: ProfilePost) -> Bool {
        self.fetchResultsController()
        self.performFetch()
        guard let posts = fetchedResultsController?.fetchedObjects else { return false }
        
        print("🍎 ", posts)
        var varibleArray = [LikePostCoreDataModel]()
        posts.forEach{ post in
            if post.idPost == profilePost.idPost {
                varibleArray.append(post)
            }
        }
        guard varibleArray.isEmpty == true else { return false }
        
        return addPostToLikePosts(profilePost)
    }
}
