//
//  CoreDataServiceFetchResult.swift
//  Navigation
//
//  Created by Андрей Банин on 17.6.23..
//

import CoreData
import UIKit

//protocol CoreDataServiceFetchResultProtocol: AnyObject {
////    func createPost(_ post: ProfilePost, completion: @escaping (Bool) -> Void)
////    func fetch<T>(
////        _ model: T.Type,
////        predicate: NSPredicate?,
////        completion: @escaping (Result<[T], Error>) -> Void
////    ) where T:NSManagedObject
////    func deletePost(predicate: NSPredicate?)
//}

@available(iOS 15.0, *)
final class CoreDataServiceFetchResult {
    
    private var context: NSManagedObjectContext?
    private var fetchedResultsController: NSFetchedResultsController<LikePostCoreDataModel>?
    
    
    func setupCoreData() {
        self.setupFetchedResultsController()
        
    }
    
    private func setupFetchedResultsController() {
        
        self.context = (UIApplication.shared.delegate as? AppDelegate)?.container?.viewContext
        
        guard let context = self.context else { fatalError() }
        
        let fetchRequest = LikePostCoreDataModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "author", ascending: true)
        fetchRequest.sortDescriptors = [
            sortDescriptor
        ]
        
        let fetchResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchResultController.delegate = self
    }
    
    
    
}

@available(iOS 15.0, *)
extension CoreDataServiceFetchResult: NSFetchedResultsControllerDelegate {
    
    
//    func createPost(_ post: ProfilePost, completion: @escaping (Bool) -> Void) {
//        <#code#>
//    }
//
//    func fetch<T>(_ model: T.Type, predicate: NSPredicate?, completion: @escaping (Result<[T], Error>) -> Void) where T : NSManagedObject {
//        <#code#>
//    }
//
//    func deletePost(predicate: NSPredicate?) {
//        <#code#>
//    }
    
    
}
