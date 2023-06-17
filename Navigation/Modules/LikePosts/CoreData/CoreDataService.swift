
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
    
    static let shared = CoreDataService()
            
    private let persistentContainer: NSPersistentContainer
    private lazy var backgroundContext = persistentContainer.newBackgroundContext()
    private lazy var mainContext = persistentContainer.viewContext

    private init() {
        let container = NSPersistentContainer(name: "CoreDataNavigation")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        self.persistentContainer = container
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
