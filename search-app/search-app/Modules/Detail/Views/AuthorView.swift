//
//  AuthorView.swift
//  search-app
//
//  Created by Evelina on 12.09.2024.
//

import Foundation
import UIKit

class AuthorView: UIView {
    
    //MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let nameLabelFontSize: CGFloat = 14
        static let usernameLabelFontSize: CGFloat = 14
        static let imageViewSize: CGFloat = 50
        static let hStackSpacing: CGFloat = 10
        static let labelsNumberOfLines: Int = 1
        static let imageViewCornerRadius: CGFloat = 20
    }
    
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI properties
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = UIConstants.imageViewCornerRadius
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = UIConstants.labelsNumberOfLines
        label.font = .boldSystemFont(ofSize: UIConstants.nameLabelFontSize)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = UIConstants.labelsNumberOfLines
        label.font = .systemFont(ofSize: UIConstants.usernameLabelFontSize)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Private functions
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let vStack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.alignment = .fill
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        let hStack = UIStackView(arrangedSubviews: [imageView, vStack])
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.spacing = UIConstants.hStackSpacing
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: self.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            vStack.heightAnchor.constraint(equalTo: hStack.heightAnchor),
        ])
        
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        vStack.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    //MARK: - Public functions
    func setAuthorData(image: UIImage?, name: String?, username: String?) {
        imageView.image = image
        nameLabel.text = name
        usernameLabel.text = username
    }
}
