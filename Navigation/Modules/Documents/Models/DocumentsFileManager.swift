
import Foundation

struct DocumentsFileManager {
    
    
//    let fileData = Data()
    func manager() {
        do {
            let manager = FileManager.default
            let documentsUrl = try manager.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
            
            
            
            print(documentsUrl)
        } catch {
            print("error")
        }
    }
    
    
    
}

