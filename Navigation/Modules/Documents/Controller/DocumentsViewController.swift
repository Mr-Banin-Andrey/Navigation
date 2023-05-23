import Foundation
import UIKit
import SnapKit

class DocumentsViewController: UIViewController {
    
    var coordinator: DocumentsCoordinator?
    
    private lazy var documentsView = DocumentsView(delegate: self)
        
    private var images: [UIImage] = []
        
    override func loadView() {
        super.loadView()
        view = documentsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentsView.configureTableView(dataSource: self, delegate: self)
        documentsView.navigationController(navigation: navigationItem, rightButton: documentsView.rightButton, title: "Documents")
    }
}


extension DocumentsViewController: DocumentsViewDelegate {
    func addImage() {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension DocumentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCellId", for: indexPath)
        
        cell.imageView?.image = images[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIScreen.main.bounds.size.height / 4
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            
            DocumentsFileManager().managerDeleteImage()
            self.images.removeAll()
            self.documentsView.reload()
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}

extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  else { return }
        
        images.removeAll()
        images.append(image)
        
        DocumentsFileManager().managerAddImage(image)
        documentsView.reload()
        
        picker.dismiss(animated: true)
    }
}
