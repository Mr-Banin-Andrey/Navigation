
import Foundation
import CoreData

protocol CoreDataServiseProtocol: AnyObject {}

final class CoreDataService {
    
    // 4.Context
    private let objectModel: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    init() {
        // 1.NSManagedObjectModel
        
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
        
        // 2.NSPersistantStoreCoordinator
        
        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.objectModel)
        
        // 3.NSPersistantStore
        
        let storeName = name + "sqlite"
        let documentsDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let persistantStoreUrl = documentsDirectoryUrl?.appendingPathComponent(storeName)
        
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

extension CoreDataService: CoreDataServiseProtocol {
    
}
