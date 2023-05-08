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
    
    let alertController = UIAlertController(title: "Question", message: "red or blue", preferredStyle: .alert)
    
    weak var coordinator: FeedCoordinator?
    
    private var timer: Timer = Timer()
    
    
    //MARK: - 2. Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadJson()
        self.loadJsonCodable() 
        
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
    
    
    func setupConstraints() {
        view.addSubview(button)
        view.addSubview(self.titleLabel)
        view.addSubview(self.orbitalPeriodLabel)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
            self.titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            self.orbitalPeriodLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            self.orbitalPeriodLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
