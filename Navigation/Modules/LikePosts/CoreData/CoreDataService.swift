
import Foundation
import CoreData

protocol CoreDataServiseProtocol: AnyObject {
    func createPost(_ post: ProfilePost, completion: @escaping (Bool) -> Void)
    func fenchPosts(predicate: NSPredicate?) -> [LikePostCoreDataModel]
    func deletePost(predicate: NSPredicate?) -> Bool
}

@available(iOS 15.0, *)
extension CoreDataService {
    
    func fenchPosts() -> [LikePostCoreDataModel] {
        self.fenchPosts(predicate: nil)
    }
}

@available(iOS 15.0, *)
final class CoreDataService {
    
    private let objectModel: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    // 4.Context
    
    private lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = self.persistentStoreCoordinator
        return context
    }()
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        backgroundContext.mergePolicy = NSOverwriteMergePolicy
        return backgroundContext
    }()
    
    init() {
        /// 1.NSManagedObjectModel
        
        guard let url = Bundle.main.url(forResource: "CoreDataNavigation", withExtension: "momd") else {
            fatalError("There is no xcdatamodeld file.")
        }

        let path = url.pathExtension
        guard let name = try? url.lastPathComponent.replace(path, replacement: "") else {
            fatalError()
        }

        guard let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Can`t create NSManagedObjectModel")
        }

        self.objectModel = model
        
        /// 2.NSPersistantStoreCoordinator
        
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.objectModel)
        
        /// 3.NSPersistantStore
        
        let storeName = name + "sqlite"
        let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let persistantStoreUrl = documentsDirectoryUrl?.appendingPathComponent(storeName)
        
        print("✅", persistantStoreUrl!)
        
        guard let persistantStoreUrl = persistantStoreUrl else { return }

        let options = [NSMigratePersistentStoresAutomaticallyOption:true]
        do {
            try self.persistentStoreCoordinator.addPersistentStore(
                type: .sqlite,
                at: persistantStoreUrl,
                options: options
            )
        } catch {
            fatalError("Can't create NSPersistantStore")
        }
    }
}

@available(iOS 15.0, *)
extension CoreDataService: CoreDataServiseProtocol {
    
    func createPost(_ post: ProfilePost, completion: @escaping (Bool) -> Void) {
        
        self.backgroundContext.perform {
            let likePostCoreDataModel = LikePostCoreDataModel(context: self.backgroundContext)
            
            likePostCoreDataModel.idPost = post.idPost
            likePostCoreDataModel.author = post.author
            likePostCoreDataModel.descriptionPost = post.description
            likePostCoreDataModel.photoPost = post.photoPost
            likePostCoreDataModel.likes = Int64(post.likes)
            likePostCoreDataModel.views = Int64(post.views)
            
            guard self.backgroundContext.hasChanges else {
                self.mainContext.perform {
                    completion(false)
                }
                return
            }
            
            do {
                try self.backgroundContext.save()
                
                self.mainContext.perform {
                    completion(true)
                }
                
            } catch {
                self.mainContext.perform {
                    print("Error добавлении в базу: ", error.localizedDescription)
                    completion(false)
                }
            }
        }
    }
    
    func fenchPosts(predicate: NSPredicate?) -> [LikePostCoreDataModel] {
        let fetchRequest = LikePostCoreDataModel.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let storedPosts = try self.mainContext.fetch(fetchRequest)
            return storedPosts
        } catch {
            return []
        }
    }
    
    func deletePost(predicate: NSPredicate?) -> Bool {
        let posts = self.fenchPosts(predicate: predicate)
        
        posts.forEach {
            self.mainContext.delete($0)
        }
        
        guard self.mainContext.hasChanges else {
            return false
        }
        
        do {
            try self.mainContext.save()
            return true
        } catch {
            return false
        }
    }
}
