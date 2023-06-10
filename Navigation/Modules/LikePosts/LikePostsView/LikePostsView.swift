

import Foundation
import UIKit
import SnapKit

protocol LikePostsViewDelegate: AnyObject {
    
}

class LikePostsView: UIView {
    
    private weak var delegate: LikePostsViewDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(delegate: LikePostsViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        self.setupUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurationTableView(
        dataSourse: UITableViewDataSource,
        delegate: UITableViewDelegate
    ) {
        tableView.dataSource = dataSourse
        tableView.delegate = delegate
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    private func setupUi() {
        self.addSubview(self.tableView)
        
        self.tableView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
        }
    }
}
