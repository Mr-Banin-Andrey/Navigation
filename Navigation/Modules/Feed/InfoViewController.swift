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
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = Json().perem
        return label
    }()
    
    let alertController = UIAlertController(title: "Question", message: "red or blue", preferredStyle: .alert)
    
    weak var coordinator: FeedCoordinator?
    
    private var timer: Timer = Timer()
    
    
    //MARK: - 2. Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadJson()
        
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        setupConstraints()
        setupAlertController()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.timerStart()
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//            super.viewDidDisappear(animated)
//        timer.invalidate()
//        print("timer.invalidate() - viewDidDisappear")
//    }
    
    
    //MARK: - 3. Methods
    
    func loadJson() {
        
        if let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let unrappedData = data {
                    
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: unrappedData)
                        print(dictionary)
                        
                        if let dict = dictionary as? [String: Any], let title = dict["title"] as? String {
                                DispatchQueue.main.async {
                                    self.titleLabel.text = title
                                    print(title)
                                }
                        }
                    }
                    catch let error {
                        print(error.localizedDescription)
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
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            self.titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
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
