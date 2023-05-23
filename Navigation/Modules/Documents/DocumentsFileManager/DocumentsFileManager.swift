
import Foundation
import UIKit

struct DocumentsFileManager {
    
    private let manager = FileManager.default
    
    private func documentsUrl() -> URL {
        do {
            let documentsUrl = try manager.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
            
            let imagePath = documentsUrl.appendingPathComponent("image.jpg")
            return imagePath
        } catch let error {
            print(error, "error")
        }
        return URL(fileURLWithPath: "")
    }
    
    
    func managerAddImage(_ image: UIImage) {
        let data = image.jpegData(compressionQuality: 1.0)
        manager.createFile(atPath: documentsUrl().relativePath, contents: data)
    }
    
    func managerDeleteImage() {
        do {
            try manager.removeItem(atPath: documentsUrl().relativePath)
        } catch let error {
            print("error", error)
        }
    }
}

