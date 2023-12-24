//
//  LoadingReusableView.swift
//  ProjectMarvel
//
//  Created by Dustin Tong on 2/11/24.
//

import Foundation
import UIKit

class LoadingReusableView: UICollectionReusableView {
    let activityIndicator = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(activityIndicator)
        activityIndicator.center = self.center
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
