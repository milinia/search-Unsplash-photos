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
    
    // MARK: - Override functions
    override func prepareForReuse() {
        mediaImageView.image = nil
    }
    
    // MARK: - Private functions
    private func initialize() {
        backgroundColor = .white
        layer.cornerRadius = UIConstants.viewCornerRadius
        
        let vStack = UIStackView(arrangedSubviews: [mediaImageView])
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.alignment = .center
        vStack.spacing = UIConstants.vStackSpacing
        vStack.translatesAutoresizingMaskIntoConstraints = false
    
        addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.contentInset),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UIConstants.contentInset),
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIConstants.contentInset),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIConstants.contentInset),
        ])
    }
    
    // MARK: - Public functions
    func setImage(image: UIImage) {
        mediaImageView.image = image
    }
}
