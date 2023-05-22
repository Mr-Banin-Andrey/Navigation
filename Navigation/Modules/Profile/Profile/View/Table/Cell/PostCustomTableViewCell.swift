
import UIKit

class PostCustomTableViewCell: UITableViewCell {
    
    private lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.font = .systemFont(ofSize: 20, weight: .bold)
        authorLabel.numberOfLines = 2
        authorLabel.textColor = .black
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        return authorLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .systemGray
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .heavy)
        return descriptionLabel
    }()
    
    private lazy var imagePhotoView: UIImageView = {
        let imagePhotoView = UIImageView()
        imagePhotoView.contentMode = .scaleAspectFit
        imagePhotoView.translatesAutoresizingMaskIntoConstraints = false
        imagePhotoView.backgroundColor = .black
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
        likesLabel.textColor = .black
        likesLabel.font = .systemFont(ofSize: 16, weight: .medium)
        return likesLabel
    }()
    
    private lazy var likesAmountLabel: UILabel = {
        let likesAmountLabel = UILabel()
        likesAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        likesAmountLabel.textColor = .black
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
        viewsLabel.textColor = .black
        viewsLabel.text = "Views:"
        return viewsLabel
    }()
    
    private lazy var viewsAmountLabel: UILabel = {
        let viewsAmountLabel = UILabel()
        viewsAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsAmountLabel.textColor = .black
        viewsAmountLabel.font = .systemFont(ofSize: 16, weight: .medium)
        return viewsAmountLabel
    }()
    
//MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        let viewsAmountText = String(profilePost.views)
        let likesAmountText = String(profilePost.likes)
        
        self.authorLabel.text = profilePost.author
        self.descriptionLabel.text = profilePost.description
        self.imagePhotoView.image = profilePost.photoPost.photoPost
        self.viewsAmountLabel.text = viewsAmountText
        self.likesAmountLabel.text = likesAmountText
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
}

extension String {
    var photoPost: UIImage? { get { return UIImage(named: self) } }
}
