//
//  MediaCollectionViewCell.swift
//  DesafioGloboPlay
//
//  Created by Juliana Marchl on 17/11/24.
//

import UIKit
import SDWebImage

class MediaCollectionViewCell: UICollectionViewCell {
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with model: String) {        
        guard let url = URL(string: Constants.imgUrl + model) else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
}
