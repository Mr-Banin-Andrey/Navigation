//
//  CoreDataServiceFetchResult.swift
//  Navigation
//
//  Created by Андрей Банин on 17.6.23..
//

import CoreData
import UIKit


@available(iOS 15.0, *)
final class CoreDataServiceFetchResult {
    
    let context: NSManagedObjectContext?
    let fetchedResultsController: NSFetchedResultsController<LikePostCoreDataModel>
    let fetchRequest: NSFetchRequest<LikePostCoreDataModel>
        
    init() {
        
        self.context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        
        guard let context = self.context else { fatalError() }
        
        fetchRequest = LikePostCoreDataModel.fetchRequest()
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
    
    
    func fetchLikePosts() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("Can't fetch data from db")
        }
    }
    
    func addPost(_ profilePost: ProfilePost) {
        
        guard
            let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        else { return }
                    
        let postModel = LikePostCoreDataModel(context: context)
        postModel.idPost = profilePost.idPost
        postModel.author = profilePost.author
        postModel.descriptionPost = profilePost.description
        postModel.photoPost = profilePost.photoPost
        postModel.likes = Int64(profilePost.likes)
        postModel.views = Int64(profilePost.views)
    }
}
