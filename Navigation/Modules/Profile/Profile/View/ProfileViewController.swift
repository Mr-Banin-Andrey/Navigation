

import UIKit
//import iOSIntPackage

@available(iOS 15.0, *)
class ProfileViewController: UIViewController {
    
    var coordinator: ProfileCoordinator?
    
    private let coreDataService: CoreDataService = CoreDataService()
    
    //MARK: - 1. Properties
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "headerId")
        tableView.register(PostCustomTableViewCell.self, forCellReuseIdentifier: "tableId")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "photosId")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultId")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var imageViewBig: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = ReleaseOrTest().user.userPhoto.userPhoto
        image.isHidden = true
        image.clipsToBounds = true
        image.layer.cornerRadius = 50
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
    private lazy var viewBlur: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = .black
        view.alpha = 0.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var closeImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.closeImageView), for: .touchUpInside)
        button.setImage(.init(systemName: "xmark"), for: .normal)
        button.tintColor = .white
        button.isHidden = true
        return button
    }()
    
    private lazy var likeLabel: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "hand.thumbsup.fill")
        image.tintColor = UIColor(named: "blueColor")
        image.isHidden = true
        return image
    }()
    
    private var imageWidthConstaint: NSLayoutConstraint?
    private var imageHeightConstaint: NSLayoutConstraint?
    
    private var isImageViewBigIncreased = false
    
    //MARK: - 2. Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.tapGesture()
        self.viewSetupConstraints()
        
        #if DEBUG
            self.tableView.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        #else
            self.view.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        #endif
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - 3. Methods
    private func viewSetupConstraints() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.viewBlur)
        self.view.addSubview(self.imageViewBig)
        self.view.addSubview(self.closeImageButton)
        self.view.addSubview(self.likeLabel)
        
        self.imageWidthConstaint = self.imageViewBig.widthAnchor.constraint(equalToConstant: 100)
        self.imageHeightConstaint = self.imageViewBig.heightAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.viewBlur.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.viewBlur.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.viewBlur.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.viewBlur.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.closeImageButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.closeImageButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            
            self.imageWidthConstaint,
            self.imageHeightConstaint,
            self.imageViewBig.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            self.imageViewBig.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            
            self.likeLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.likeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.likeLabel.widthAnchor.constraint(equalToConstant: 100),
            self.likeLabel.heightAnchor.constraint(equalToConstant: 100)
        ].compactMap({ $0 }))
    }
    
    private func layoutZoomImage(completion: @escaping () -> Void) {
        self.imageWidthConstaint?.constant = self.isImageViewBigIncreased ? 100 : self.view.bounds.width
        self.imageHeightConstaint?.constant = self.isImageViewBigIncreased ? 100 : self.view.bounds.width
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut) {
            self.view.layoutIfNeeded()
            self.viewBlur.alpha = 0.8
            self.imageViewBig.center = self.view.center
            self.viewBlur.isHidden = false
            self.imageViewBig.isHidden = false
        } completion: { _ in
            completion()
            self.closeImageButton.isHidden = false
        }
    }
    
    private func animateCloseView(completion: @escaping () -> Void) {
        self.imageWidthConstaint?.constant = self.isImageViewBigIncreased ? self.view.bounds.width : 100
        self.imageHeightConstaint?.constant = self.isImageViewBigIncreased ? self.view.bounds.width : 100

        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) {
            self.imageViewBig.frame.origin.x = CGFloat(0)
            self.imageViewBig.frame.origin.y = CGFloat(0)
            self.view.layoutIfNeeded()
            self.closeImageButton.isHidden = true
            self.viewBlur.alpha = 0.0
        } completion: { _ in
            completion()
            self.imageViewBig.isHidden = true
            self.viewBlur.isHidden = true
            self.tableView.isUserInteractionEnabled = true
        }
    }
    
    private func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapEdit(recognizer:)))
        tapGesture.numberOfTapsRequired = 2
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    private func showLikeLabel() {
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenDivision5 = UIScreen.main.bounds.size.width / 5
        let screenHeightDivision2 = UIScreen.main.bounds.size.height / 2
        let startPoint = self.likeLabel.center
        
        likeLabel.isHidden = false

        UIView.animate(withDuration: 2.0) {
            self.likeLabel.center = CGPoint(x: (screenWidth - screenDivision5), y: screenHeightDivision2 * 2)
            self.likeLabel.alpha = 0.0
        } completion: { _ in
            self.likeLabel.center = startPoint
            self.likeLabel.isHidden = true
            self.likeLabel.alpha = 1.0
        }
    }
    
    @objc func tapEdit(recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                if let _ = self.tableView.cellForRow(at: tapIndexPath) as? PostCustomTableViewCell {
                    print("tapEdit")
                }
            }
        }
    }
    
    @objc func zoomPicture(_ gestureRecognizer: UITapGestureRecognizer) {

        self.tableView.isUserInteractionEnabled = false // делает таблицу неактивной
        
        let viewOriginY = self.view.safeAreaLayoutGuide.layoutFrame.origin.y
        tableView.setContentOffset(CGPoint(x: 0, y: -viewOriginY), animated: true)

        let completion: () -> Void = { [weak self] in
            self?.tableView.isUserInteractionEnabled = true
        }
        self.layoutZoomImage(completion: completion)
    }
    
    @objc func closeImageView() {
        let completion: () -> Void = { [weak self] in
            self?.tableView.isUserInteractionEnabled = true
        }
        self.animateCloseView(completion: completion)
    }
    
}
@available(iOS 15.0, *)
extension ProfileViewController: PostCustomTableViewCellDelegate, UIGestureRecognizerDelegate {
    func tapLikePost(_ profilePost: ProfilePost) {
        
        self.coreDataService.fetch(
            LikePostCoreDataModel.self,
            predicate: NSPredicate(format: "idPost == %@", profilePost.idPost)
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedObjects):
                
                if fetchedObjects.isEmpty == true {
                    self.coreDataService.createPost(profilePost) { [weak self] success in
                        guard let self = self else { return }
                        if success {
                            print("пост успешно добавлен в понравившиеся")
                            NotificationCenter.default.post(name: NSNotification.Name("postAdded"),
                                                            object: self)
                        }
                    }
                    showLikeLabel()
                } else {
                    ShowAlert().showAlert(vc: self, title: "Ошибка - пост есть в понравившимся", message: "Выберите другой пост", titleButton: "ну ладно")
                }
            case .failure:
                fatalError()
            }
        }
    }
}

@available(iOS 15.0, *)
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId") as? ProfileHeaderView else { return nil }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.zoomPicture(_:)))
            header.imageView.addGestureRecognizer(tapGestureRecognizer)
            
            header.setup(user: ReleaseOrTest().user)
            return header
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if section == 0 {
           return 1
        }
        
        if section == 1 {
            let posts = Posts()
            let postsArrive = (posts.postsArray.count)
            return postsArrive
        }

        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "photosId", for: indexPath) as? PhotosTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultId", for: indexPath)
                return cell
            }

            cell.selectionStyle = .none
            let photo = PhotosInCellProfile().photos[indexPath.row]
            cell.setup(with: photo)
            return cell
        }

        if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tableId", for: indexPath) as? PostCustomTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "defaultId", for: indexPath)
                return cell
            }
            
            cell.selectionStyle = .none
            let posts = Posts()
            let post = posts.postsArray[indexPath.row]
            cell.setup(with: post)
            cell.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultId", for: indexPath)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            print("didSelectRowAt")
            coordinator?.showPhotosVC()
        }
    }
}
