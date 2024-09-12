//
//  SearchResultCollectionViewCell.swift
//  search-app
//
//  Created by Evelina on 10.09.2024.
//

import Foundation
import UIKit

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 6
        static let viewCornerRadius: CGFloat = 20
        static let vStackSpacing: CGFloat = 10
    }

    // MARK: - Private UI properties
    private lazy var mediaImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayoutAndGetHeight()
    }
    
    override func prepareForReuse() {
        mediaImageView.image = nil
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.frame.size.width = size.width
        let height = setupLayoutAndGetHeight()
        return CGSize(width: size.width, height: height)
    }
    
    @discardableResult
    private func setupLayoutAndGetHeight() -> CGFloat {
        let imageWidth = contentView.bounds.width - UIConstants.contentInset * 2
        let imageHeight = imageWidth * (mediaImageView.image?.size.height ?? 1) / (mediaImageView.image?.size.width ?? 1)
            
        mediaImageView.frame = CGRect(x: UIConstants.contentInset,
                                 y: UIConstants.contentInset,
                                 width: imageWidth,
                                 height: imageHeight)
        return mediaImageView.frame.maxY + UIConstants.contentInset
    }
    
    // MARK: - Private functions
    private func initialize() {
        addSubview(mediaImageView)
    }
    
    // MARK: - Public functions
    func setImage(image: UIImage) {
        mediaImageView.image = image
        setNeedsLayout()
    }
}
