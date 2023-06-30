

import UIKit

class InfoViewController: UIViewController {
    
    //MARK: - 1. Properties
    private lazy var button: CustomButton = {
        let button = CustomButton(title: "infoVC.button.title".localized, bgColor: .blue) { [unowned self] in
            self.present(alertController, animated: true, completion: nil)
        }
        return button
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var orbitalPeriodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "defaultId")
        table.isHidden = true
        table.isUserInteractionEnabled = false
        return table
    }()
    
    let alertController = UIAlertController(
        title: "infoVC.alert.title".localized,
        message: "infoVC.alert.message".localized,
        preferredStyle: .alert
    )
    
    weak var coordinator: FeedCoordinator?
    
    private var timer: Timer = Timer()
            
    private var namesOfResidentsArray: [String] = []
    
    //MARK: - 2. Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadJson()
        
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        setupConstraints()
        setupAlertController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.timerStart()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
        print("timer.invalidate() - viewDidDisappear")
    }
    
    
    //MARK: - 3. Methods
    
    private func loadJson() {
        TitleJsonSerialization.shared.loadJson { [weak self] value in
            guard let self else { return }
            DispatchQueue.main.async {
                self.titleLabel.text = "\("infoVC.titleLabel.text".localized) \(value)"
                print(value, "TitleJsonSerialization")
            }
        }
        
        OrbitalPeriodJsonSingleton.shared.loadJson { [weak self] value in
            guard let self else { return }
            DispatchQueue.main.async {
                self.orbitalPeriodLabel.text = "\("infoVC.orbitalPeriodLabel.text".localized) \(value)"
                print(value, "OrbitalPeriodJsonSingleton")
            }
        }

        
        NamesOfResidentsJsonSingleton.shared.loadJsonDecodablePlanet { [weak self] values in
            guard let self else { return }
            
            NamesOfResidentsJsonSingleton.shared.loadUrlNamesOfResidents(url: values) { [weak self] names in
                guard let self else { return }
                self.namesOfResidentsArray = names
                print(namesOfResidentsArray)
                
                DispatchQueue.main.async {
                    self.tableView.isHidden = false
                    self.tableView.isUserInteractionEnabled = true
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func setupConstraints() {
        view.addSubview(button)
        view.addSubview(self.titleLabel)
        view.addSubview(self.orbitalPeriodLabel)
        view.addSubview(self.tableView)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
            self.titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            self.orbitalPeriodLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            self.orbitalPeriodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            self.tableView.topAnchor.constraint(equalTo: self.button.bottomAnchor, constant: 24),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    func setupAlertController() {
        alertController.addAction(UIAlertAction(
            title: "infoVC.alert.action.leftButton.title".localized,
            style: .default,
            handler: { _ in
                print("left button")
            })
        )
        alertController.addAction(UIAlertAction(
            title: "infoVC.alert.action.rightButton.title".localized,
            style: .default,
            handler: { _ in
                print("right button")
            })
        )
    }
    
    private func timerStart() {
        timer = Timer.scheduledTimer(timeInterval: 5.0,
                                 target: self,
                                 selector: #selector(autoEditColor),
                                 userInfo: nil,
                                 repeats: true)
    }
    
    @objc private func autoEditColor() {
        button.backgroundColor = UIColor(red: .random(in: 0...1),
                                       green: .random(in: 0...1),
                                       blue: .random(in: 0...1),
                                       alpha: .random(in: 0...1))
    }
    
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if namesOfResidentsArray.isEmpty == true {
            return 1
        } else {
            return namesOfResidentsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultId", for: indexPath)
        
        if namesOfResidentsArray.isEmpty == true {
            cell.textLabel?.text = "infoVC.cell.textLabel.text".localized
        } else {
            cell.textLabel?.text = namesOfResidentsArray[indexPath.row]
        }

        return cell
    }
}
