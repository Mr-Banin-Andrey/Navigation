//
//  InfoViewController.swift
//  Navigation
//
//  Created by Андрей Банин on 19.10.22..
//

import UIKit

class InfoViewController: UIViewController {
    
    //MARK: - 1. Properties
    private lazy var button: CustomButton = {
        let button = CustomButton(title: "click", bgColor: .blue) { [unowned self] in
            self.present(alertController, animated: true, completion: nil)
        }
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var orbitalPeriodLabel: UILabel = {
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
//        table.isHidden = true
//        table.isUserInteractionEnabled = false
        return table
    }()
    
    let alertController = UIAlertController(title: "Question", message: "red or blue", preferredStyle: .alert)
    
    weak var coordinator: FeedCoordinator?
    
    private var timer: Timer = Timer()
    
    private var urlNamesOfResidents: [String] = []
    
    private var namesOfResidentsArray: [String] = []
    
    //MARK: - 2. Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadJson()
        self.loadJsonCodable()
        self.loadJsonDecodablePlanet { [weak self] values in
            guard let self else { return }
            self.urlNamesOfResidents = values
            print(urlNamesOfResidents)
        }
        
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
    
    func loadJson()  {

        if let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let unrappedData = data {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: unrappedData)
                        print(dictionary)
                        
                        if let dict = dictionary as? [String: Any], let title = dict["title"] as? String {
                            DispatchQueue.main.async {
                                self.titleLabel.text = "Title - \(title)"
                            }
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }
            task.resume()
        } else {
            print("Cannot create URL")
        }
    }
    
    func loadJsonCodable()  {

        if let url = URL(string: "https://swapi.dev/api/planets/1/") {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let unrappedData = data {
                    
                    do {
                        let planet = try JSONDecoder().decode(Planet.self, from: unrappedData)
                        print(planet)
                        
                        DispatchQueue.main.async {
                            self.orbitalPeriodLabel.text = "Период обращения - \(planet.orbital_period)"
                        }
                    } catch let error {
                        print(error)
                    }
                   
                }
            }
            task.resume()
        } else {
            print("Cannot create URL")
        }
    }
    
    func loadJsonDecodablePlanet(completion: @escaping ([String]) -> Void)  {

        if let url = URL(string: "https://swapi.dev/api/planets/1/") {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let unrappedData = data {
                    
                    do {
                        let planet = try JSONDecoder().decode(CharacterOfPlanet.self, from: unrappedData)
                        print(planet)
                        
                        completion(planet.residents)
                        
                    } catch let error {
                        print(error)
                    }
                   
                }
            }
            task.resume()
        } else {
            print("Cannot create URL")
        }
    }
    
    func loadUrlNamesOfResidents(url: [String]) {
        
        url.forEach { value in
            if let url = URL(string: value) {
                
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    
                    if let unrappedData = data {
                        
                        do {
                            let planet = try JSONDecoder().decode(NamesOfResidents.self, from: unrappedData)
                            
                            self.namesOfResidentsArray.append(planet.name)
                            print(planet.name)
                            
                        } catch let error {
                            print(error)
                        }
                    }
                }
                task.resume()
            } else {
                print("Cannot create URL")
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
        alertController.addAction(UIAlertAction(title: "red", style: .default, handler: { _ in
            print("left button")
        }))
        alertController.addAction(UIAlertAction(title: "blue", style: .default, handler: { _ in
            print("right button")
        }))
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
            cell.textLabel?.text = "empty"
        } else {
            cell.textLabel?.text = namesOfResidentsArray[indexPath.row]
        }
//        cell.backgroundColor = UIColor.brown
        return cell
    }
    
    
}
