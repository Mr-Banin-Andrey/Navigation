
import UIKit

protocol PostCustomTableViewCellDelegate: AnyObject {
    func tapLikePost(_ profilePost: ProfilePost)
}

class PostCustomTableViewCell: UITableViewCell {
    
    weak var delegate: PostCustomTableViewCellDelegate?
    
    private lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.font = .systemFont(ofSize: 20, weight: .bold)
        authorLabel.numberOfLines = 2
        authorLabel.textColor = .label
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        return authorLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .heavy)
        return descriptionLabel
    }()
    
    private lazy var imagePhotoView: UIImageView = {
        let imagePhotoView = UIImageView()
        imagePhotoView.contentMode = .scaleAspectFit
        imagePhotoView.translatesAutoresizingMaskIntoConstraints = false
        imagePhotoView.backgroundColor = .tertiarySystemBackground
        return imagePhotoView
    }()
    
    private lazy var likesStack: UIStackView = {
        let likesStack = UIStackView()
        likesStack.translatesAutoresizingMaskIntoConstraints = false
        likesStack.axis = .horizontal
        likesStack.distribution = .fill
        likesStack.spacing = 5
        return likesStack
    }()
    
    private lazy var likesLabel: UILabel = {
        let likesLabel = UILabel()
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.text = "Likes:"
        likesLabel.textColor = .label
        likesLabel.font = .systemFont(ofSize: 16, weight: .medium)
        return likesLabel
    }()
    
    private lazy var likesAmountLabel: UILabel = {
        let likesAmountLabel = UILabel()
        likesAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        likesAmountLabel.textColor = .label
        likesAmountLabel.font = .systemFont(ofSize: 16, weight: .medium)
        return likesAmountLabel
    }()
    
    private lazy var viewsStack: UIStackView = {
        let viewsStack = UIStackView()
        viewsStack.axis = .horizontal
        viewsStack.spacing = 5
        viewsStack.distribution = .fill
        viewsStack.translatesAutoresizingMaskIntoConstraints = false
        return viewsStack
    }()
    
    private lazy var viewsLabel: UILabel = {
        let viewsLabel = UILabel()
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.font = .systemFont(ofSize: 16, weight: .medium)
        viewsLabel.textColor = .label
        viewsLabel.text = "Views:"
        return viewsLabel
    }()
    
    private lazy var viewsAmountLabel: UILabel = {
        let viewsAmountLabel = UILabel()
        viewsAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsAmountLabel.textColor = .label
        viewsAmountLabel.font = .systemFont(ofSize: 16, weight: .medium)
        return viewsAmountLabel
    }()
    
    private lazy var namePhoto = ""
    
    private lazy var idPost = ""
    
//MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .secondarySystemBackground
        
        self.tapGesture()
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.authorLabel.text = nil
        self.descriptionLabel.text = nil
        self.imagePhotoView.image = nil
        self.viewsAmountLabel.text = nil
        self.likesAmountLabel.text = nil
    }
    
    func setup(with profilePost: ProfilePost) {
        
        likesAmountLabel.isHidden = true
        
        let viewsAmountText = String(profilePost.views)
        let likesAmountText = String(profilePost.likes)
        
        
        self.authorLabel.text = profilePost.author
        self.descriptionLabel.text = profilePost.description
        self.imagePhotoView.image = profilePost.photoPost.photoPost
        self.viewsAmountLabel.text = viewsAmountText
        self.likesAmountLabel.text = likesAmountText
        self.idPost = profilePost.idPost
        
        namePhoto = profilePost.photoPost
        
        let localizableLikes = NSLocalizedString("any.likes", comment: "")
        let formattedLikes = String(format: localizableLikes, profilePost.likes)
        
        self.likesLabel.text = formattedLikes
        
    }
    
    func setupModel(with likePostsCoreDataModel: LikePostCoreDataModel) {
        
//        likesAmountLabel.isHidden = true
        
        self.authorLabel.text = likePostsCoreDataModel.author
        self.descriptionLabel.text = likePostsCoreDataModel.descriptionPost
        self.imagePhotoView.image = likePostsCoreDataModel.photoPost?.photoPost
        self.viewsAmountLabel.text = String(likePostsCoreDataModel.views)
        self.likesAmountLabel.text = String(likePostsCoreDataModel.likes)
        
        
        self.idPost = likePostsCoreDataModel.idPost ?? ""
        
        namePhoto = likePostsCoreDataModel.photoPost ?? ""
    }
    
    
    private func setupConstraints() {
        
        self.contentView.addSubview(self.authorLabel)
        self.contentView.addSubview(self.descriptionLabel)
        self.contentView.addSubview(self.imagePhotoView)
        
        self.contentView.addSubview(self.viewsStack)
        self.viewsStack.addArrangedSubview(self.viewsLabel)
        self.viewsStack.addArrangedSubview(self.viewsAmountLabel)
        
        self.contentView.addSubview(self.likesStack)
        self.likesStack.addArrangedSubview(self.likesLabel)
        self.likesStack.addArrangedSubview(self.likesAmountLabel)
        
        NSLayoutConstraint.activate([
            
            self.authorLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            self.authorLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.authorLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            self.imagePhotoView.topAnchor.constraint(equalTo: self.authorLabel.bottomAnchor, constant: 16),
            self.imagePhotoView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imagePhotoView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imagePhotoView.heightAnchor.constraint(equalTo: self.contentView.widthAnchor),
            
            self.descriptionLabel.topAnchor.constraint(equalTo: self.imagePhotoView.bottomAnchor, constant: 8),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            self.likesStack.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 16),
            self.likesStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.likesStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            
            self.viewsStack.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 16),
            self.viewsStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.viewsStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func tapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapEdit(_:)))
        tapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(tapGesture)
    }
    
    @objc func tapEdit(_ sender: UITapGestureRecognizer) {
        guard
            let views = viewsAmountLabel.text,
            let likes = likesAmountLabel.text
        else { return }
        
        guard
            let description = descriptionLabel.text,
            let author = authorLabel.text,
            let likes = Int(likes),
            let views = Int(views)
        else  { return }

        
        let profilePost = ProfilePost(idPost: idPost,
                                      author: author,
                                      description: description,
                                      photoPost: namePhoto,
                                      likes: likes,
                                      views: views)
        
        
        delegate?.tapLikePost(profilePost)
    }
}

extension String {
    var photoPost: UIImage? { get { return UIImage(named: self) } }
}
