
import Foundation
import UIKit
import SnapKit

protocol DocumentsViewDelegate: AnyObject {
    func addImage()
}

class DocumentsView: UIView {
    
    private weak var delegate: DocumentsViewDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    lazy var rightButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addImage))
    
    init(delegate: DocumentsViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTableView(dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCellId")
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    func navigationController(navigation: UINavigationItem, rightButton: UIBarButtonItem) {
        
        rightButton.tintColor = UIColor(named: "blueColor")
        
        navigation.rightBarButtonItems = [rightButton]
        navigation.rightBarButtonItem = rightButton
    }
    
    func setupUI() {
        self.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }
    
    @objc func addImage() {
        delegate?.addImage()
    }
}
