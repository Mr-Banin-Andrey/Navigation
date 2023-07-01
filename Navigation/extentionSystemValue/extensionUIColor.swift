

import UIKit

extension UIColor {
    
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return lightMode
        }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
    
    static var appTintColorOrange: UIColor = {
          if #available(iOS 13, *) {
              return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                  if traitCollection.userInterfaceStyle == .dark {
                      return UIColor(red: 0.9529411793, green: 0.6181941714, blue: 0, alpha: 1) // Темный цвет из палитры
                  } else {
                      return UIColor(red: 0.9764705896, green: 0.8076324034, blue: 0.4423897937, alpha: 1) // Светлый цвет из палитры
                  }
              }
          } else {
              return UIColor.systemBlue // Цвет по умолчанию
          }
      }()
    
    static var appTintColorCyan: UIColor = {
          if #available(iOS 13, *) {
              return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                  if traitCollection.userInterfaceStyle == .dark {
                      return UIColor(red: 0, green: 0.4599995544, blue: 1, alpha: 1) // Темный цвет из палитры
                  } else {
                      return UIColor(red: 0, green: 0.8098235544, blue: 1, alpha: 1) // Светлый цвет из палитры
                  }
              }
          } else {
              return UIColor.systemBlue // Цвет по умолчанию
          }
      }()
    
}
