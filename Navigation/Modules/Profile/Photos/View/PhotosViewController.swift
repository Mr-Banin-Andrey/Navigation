

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController {
    
    var coordinator: ProfileCoordinator?
    
    private enum Constants {
        static let numberOfItemsInLine: CGFloat = 3
    }
    
    //MARK: - 1. Properties
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "customCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "defaultID")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var imageArrive: [UIImage] = []
        
    var photosGallery = PhotoGallery().photos
    
    let stringToUiImage = ""
        
    //MARK: - 2. Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.photoGalleryToImageArrive()
        
        self.navigationBarFunc()
        self.setupConstraints()
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.processImagesOnThread()
    }
    
    //MARK: - 3. Methods
    private func navigationBarFunc() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Photo Gallery"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupConstraints() {
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func photoGalleryToImageArrive() {
        if imageArrive.isEmpty {
            photosGallery.forEach{ imageArrive.append(($0.photo.stringToUiImage!)) }
        }
    }
    
    func processImagesOnThread() {
        
        let imageProcessor = ImageProcessor()
        
        let startTime = Date().timeIntervalSince1970
        print("startTime", startTime)
        imageProcessor.processImagesOnThread(sourceImages: imageArrive, filter: .colorInvert, qos: .default) { photos in
            
            for (index, value) in photos.enumerated() {
                self.imageArrive[index] = UIImage(cgImage: value!)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            let endTime = Date().timeIntervalSince1970
            print("endTime", endTime)
            let elapsedTime = endTime - startTime
            print("time", elapsedTime)
        }
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.imageArrive.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as? PhotosCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultID", for: indexPath)
            return cell
        }

        
        cell.photoImage.image = self.imageArrive[indexPath.row]
//        cell.setup(with: photoGallery[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let insert = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let interItemSpacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0
        
        let wight = collectionView.frame.width - (Constants.numberOfItemsInLine - 1) * interItemSpacing - insert.left - insert.right
        let itemWight = floor(wight / Constants.numberOfItemsInLine)
        
        return CGSize(width: itemWight, height: itemWight)
    }
}

extension String {
    var stringToUiImage: UIImage? { get { return UIImage(named: self) } }
}

