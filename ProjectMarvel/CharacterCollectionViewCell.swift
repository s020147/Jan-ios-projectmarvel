//
//  Created by Dustin Tong on 2/14/24.
//


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
