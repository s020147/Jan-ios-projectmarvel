// -------------------------------------------------------------------------
// This item is the property of ResMed Ltd, and contains confidential and trade
// secret information. It may not be transferred from the custody or control of
// ResMed except as authorized in writing by an officer of ResMed. Neither this
// item nor the information it contains may be used, transferred, reproduced,
// published, or disclosed, in whole or in part, and directly or indirectly,
// except as expressly authorized by an officer of ResMed, pursuant to written
// agreement.
//
// Copyright (c) 2022 ResMed Ltd.  All rights reserved.
// -------------------------------------------------------------------------

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    var imageURL: URL? {
        didSet{
            guard let imageURL = imageURL else {
                return
            }
            load(url: imageURL)
        }
    }
    
    private func load(url: URL) {
        if let cachedImage = ImageCache.shared.object(forKey: url as NSURL) {
            DispatchQueue.global().async { [weak self] in
                self?.characterImage.image = cachedImage
            }
            return
        }

        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.characterImage.image = image
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        characterImage.roundCorners(with: 6)
        containerView.styleAsCard()
    }
    
    override func prepareForReuse() {
        characterImage.image = nil
    }
}

class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}
