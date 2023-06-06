import Foundation
import UIKit
import SnapKit

@available(iOS 16.0, *)
class DocumentsViewController: UIViewController {
    
    var coordinator: DocumentsCoordinator?
    
    private lazy var documentsView = DocumentsView(delegate: self)
        
    private let manager = DocumentsFileManager()
    
    var images: [DocumentsModel] = []
                    
    override func loadView() {
        super.loadView()
        view = documentsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = false
        navigationItem.hidesBackButton = true
        
        manager.managerFiles(manager.managerCreateUrl()) { array in
            self.images = array
            self.images.sort {
                $0.nameImage < $1.nameImage
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(moreArray),
                                               name: NSNotification.Name("senderOn"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(lessArray),
                                               name: NSNotification.Name("senderOff"),
                                               object: nil)
        
        
        self.documentsView.configureTableView(dataSource: self,
                                              delegate: self)
        
        self.documentsView.navigationController(navigation: navigationItem,
                                                rightButton: documentsView.rightButton,
                                                title: "Documents")
    }
    
    func abs(array: [DocumentsModel]) {
        images = array
        images.sort {
            $0.nameImage < $1.nameImage
        }
    }
    
    @objc func moreArray() {
        manager.managerFiles(manager.managerCreateUrl()) { array in
            self.images = array
            self.images.sort {
                $0.nameImage < $1.nameImage
            }
        }
        documentsView.reload()
    }
    
    @objc func lessArray() {
        manager.managerFiles(manager.managerCreateUrl()) { array in
            self.images = array
            self.images.sort {
                $0.nameImage > $1.nameImage
            }
        }
        documentsView.reload()
    }
    
}


@available(iOS 16.0, *)
extension DocumentsViewController: DocumentsViewDelegate {
    func addImage() {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true)
    }
}

@available(iOS 16.0, *)
extension DocumentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCellId", for: indexPath)
        
        cell.imageView?.image = images[indexPath.row].image
        cell.textLabel?.text = images[indexPath.row].nameImage
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            
            let nameImage = self.images[indexPath.row].nameImage
            
            self.manager.managerDeleteImage(
                self.manager.managerCreateUrl(),
                name: nameImage)

            self.images.remove(at: indexPath.row)
            self.documentsView.reload()
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
}

@available(iOS 16.0, *)
extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage  else { return }
        
        let createNameFile = manager.managerCreateName(manager.managerCreateUrl())
        let url = createNameFile.0
        let name = createNameFile.1
        
        images.append(DocumentsModel(nameImage: name, image: image))
        
        manager.managerAddImage(image, url)
        documentsView.reload()
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
