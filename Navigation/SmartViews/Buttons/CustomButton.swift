

import UIKit

final class CustomButton: UIButton {
    typealias Action = () -> Void

    var buttonAction: Action
    
    init(title: String, titleColor: UIColor, bgColor: UIColor, action: @escaping Action) {
        buttonAction = action
        super.init(frame: .zero)
        
        setTitle("  \(title)  ", for: .normal)
        backgroundColor = bgColor
        setTitleColor(titleColor, for: .normal)
        layer.cornerRadius = 9
        translatesAutoresizingMaskIntoConstraints = false
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        buttonAction()
    }
}
