
import Foundation
import UIKit

struct DocumentsFileManager {
    
    func manager(_ image: UIImage) {
        do {
            let manager = FileManager.default
            let documentsUrl = try manager.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
            
            let imagePath = documentsUrl.appendingPathComponent("image.jpg")
            let data = image.jpegData(compressionQuality: 1.0)
            
            manager.createFile(atPath: imagePath.relativePath, contents: data)
        } catch {
            print("error", error)
        }
    }
}

