import Foundation
import UIKit
import SnapKit

class DocumentsViewController: UIViewController {
    
    var coordinator: DocumentsCoordinator?
    
    private lazy var documentsView = DocumentsView(delegate: self)
    
    private var documents: [DocumentsModel] = [DocumentsModel(document: "documents")]
    
    var imagePicker = UIImagePickerController()
    var imageView = UIImageView()
    
    override func loadView() {
        super.loadView()
        view = documentsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentsView.configureTableView(dataSource: self)
        documentsView.navigationController(navigation: navigationItem, rightButton: documentsView.rightButton)
        DocumentsFileManager().manager()
    }
    
    
    
}

extension DocumentsViewController: DocumentsViewDelegate {
    func addImage() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true)
        }
//        DispatchQueue.main.async {
//            self.documentsView.reload()
//        }
    }
}

extension DocumentsViewController: UITableViewDataSource { 
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCellId", for: indexPath)
        
        cell.backgroundColor = .cyan
        cell.textLabel?.text = documents[indexPath.row].document
        
        return cell 
    }
}

extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        if let image = image[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            print(imageView.image!, "imageView.image")
        }
        
//    }]UIImage!, editingInfo: NSDictionary!) {

//        print("image-1")
//
//        self.dismiss(animated: false, completion: { () -> Void in
//            print("image-2")
//        })
//        print("image-3")
//        imageView.image = image
//        print(imageView.image!, "imageView.image")
    }
}
