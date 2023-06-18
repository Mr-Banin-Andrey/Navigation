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
    
    var context: NSManagedObjectContext?
    var fetchedResultsController: NSFetchedResultsController<LikePostCoreDataModel>?
    
        
    func setupFetchedResultsController() { //completion: @escaping (NSFetchRequest<LikePostCoreDataModel>) ->Void ) {
        
        self.context = (UIApplication.shared.delegate as? AppDelegate)?.container?.viewContext
        
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
       
        
//        completion(fetchRequest)
//        completion(fetchedResultsController?.fetchedObjects)
    }
    
     func fetchLikePosts() {
        do {
            try self.fetchedResultsController?.performFetch()
        } catch {
            fatalError("Can't fetch data from db")
        }
    }
    
}
