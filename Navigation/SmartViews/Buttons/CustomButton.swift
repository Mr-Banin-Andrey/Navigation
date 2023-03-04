//
//  CustomButton.swift
//  Navigation
//
//  Created by Андрей Банин on 28.2.23..
//

import UIKit


class CustomButton: UIButton {
        
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    init(title: String) {
        super.init(frame: .zero)
        
        setTitle("  \(title)  ", for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        layer.cornerRadius = 9
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonTapped( _ selfVC: UIViewController, _ toVC: UIViewController) {
        let showVC = toVC
        selfVC.navigationController?.pushViewController(showVC, animated: true)
    }
}
