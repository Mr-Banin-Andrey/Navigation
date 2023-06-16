
import Foundation
import CoreData

protocol CoreDataServiseProtocol: AnyObject {
    func createPost(_ post: ProfilePost, completion: @escaping (Bool) -> Void)
    func fetch<T>(
        _ model: T.Type,
        predicate: NSPredicate?,
        completion: @escaping (Result<[T], Error>) -> Void
    ) where T:NSManagedObject
    func deletePost(predicate: NSPredicate?)
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
    
    func fetch<T>(
        _ model: T.Type,
        predicate: NSPredicate?,
        completion: @escaping (Result<[T], Error>) -> Void
    ) where T:NSManagedObject {
        let fetchRequest = model.fetchRequest()
        fetchRequest.predicate = predicate
        
        guard
            let fetchRequestResult = try? self.mainContext.fetch(fetchRequest),
            let fetchedObjects = fetchRequestResult as? [T]
        else {
            self.mainContext.perform {
                completion(.failure(NSError()))
            }
            return
        }
        
        self.mainContext.perform {
            completion(.success(fetchedObjects))
        }
    }
    
    func deletePost(predicate: NSPredicate?)  {
        self.fetch(LikePostCoreDataModel.self, predicate: predicate) { [weak self] result in

            guard let self = self else { return }

            switch result {
            case .success(let fetchedObject):
                fetchedObject.forEach {
                    self.mainContext.delete($0)
                }

                guard self.mainContext.hasChanges else {
                    fatalError()
                }

                do {
                    try self.mainContext.save()
                } catch {
                    fatalError()
                }
            case .failure:
                fatalError()
            }
        }
    
    }
}
