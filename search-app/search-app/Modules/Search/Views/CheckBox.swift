//
//  CheckBox.swift
//  search-app
//
//  Created by Evelina on 11.09.2024.
//

import Foundation
import UIKit

final class CheckBox: UIView {
    
    // MARK: - Properties
    var isCheck: Bool = false
    
    // MARK: - Private properties
    private enum UIConstants {
        static let checkmarkImageMultiplier: CGFloat = 0.8
        static let viewCornerRadius: CGFloat = 5
        static let animatingDuration: CGFloat = 0.3
    }
    
    private lazy var checkmarkImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "checkmark")
        image.contentMode = .scaleAspectFit
        image.tintColor = .black
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
    
    // MARK: - Private functions
    private func initialize() {
        layer.cornerRadius = UIConstants.viewCornerRadius
        backgroundColor = .white
        addSubview(checkmarkImage)
        checkmarkImage.isHidden = true
        NSLayoutConstraint.activate([
            checkmarkImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            checkmarkImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkmarkImage.widthAnchor.constraint(equalTo: self.widthAnchor,
                                                  multiplier: UIConstants.checkmarkImageMultiplier),
            checkmarkImage.heightAnchor.constraint(equalTo: self.heightAnchor,
                                                   multiplier: UIConstants.checkmarkImageMultiplier)
        ])
    }
    
    // MARK: - Public functions
    func check() {
        UIView.animate(withDuration: UIConstants.animatingDuration) {
            self.checkmarkImage.isHidden = false
        }
        isCheck = true
    }
    func uncheck() {
        UIView.animate(withDuration: UIConstants.animatingDuration) {
            self.checkmarkImage.isHidden = true
        }
        isCheck = false
    }
}
