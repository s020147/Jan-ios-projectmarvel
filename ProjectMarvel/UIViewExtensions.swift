
import UIKit

extension UIView {
    
    // Styles a view as a Card with rounded corners and a slight drop shadow
    func styleAsCard(with cornerRadius: CGFloat = 10.0) {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.cornerRadius = cornerRadius
    }
    
    func roundCorners(with cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
}
 
