//
//  InfoView.swift
//  search-app
//
//  Created by Evelina on 12.09.2024.
//

import Foundation
import UIKit

class InfoView: UIView {
    
    //MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let titleLabelFontSize: CGFloat = 16
        static let hStackSpacing: CGFloat = 10
        static let textLabelNumberOfLines: Int = 1
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
    private lazy var mediaImageView: UIImageView = {
        let image = UIImageView()
        image.tintColor = .darkGray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = UIConstants.textLabelNumberOfLines
        label.font = .systemFont(ofSize: UIConstants.titleLabelFontSize)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Private functions
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let hStack = UIStackView(arrangedSubviews: [mediaImageView, textLabel])
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.alignment = .fill
        hStack.spacing = UIConstants.hStackSpacing
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: self.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        mediaImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        textLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        mediaImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    //MARK: - Public functions
    func setData(image: UIImage?, text: String?) {
        mediaImageView.image = image
        textLabel.text = text
    }
}
