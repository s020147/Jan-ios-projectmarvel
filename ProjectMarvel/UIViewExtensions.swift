
// secret information. It may not be transferred from the custody or control of
// ResMed except as authorized in writing by an officer of ResMed. Neither this
// item nor the information it contains may be used, transferred, reproduced,
// published, or disclosed, in whole or in part, and directly or indirectly,
// except as expressly authorized by an officer of ResMed, pursuant to written
// agreement.
//
// Copyright (c) 2021 ResMed Ltd.  All rights reserved.
// -------------------------------------------------------------------------

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
 
