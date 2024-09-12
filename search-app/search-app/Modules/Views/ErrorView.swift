//
//  ErrorView.swift
//  search-app
//
//  Created by Evelina on 09.09.2024.
//

import Foundation
import UIKit

protocol ErrorViewDelegate: AnyObject {
    func didTryAgainButtonTapped()
}

final class ErrorView: UIView {
    
    //MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let errorLabelFontSize: CGFloat = 30
        static let errorDescriptionLabelFontSize: CGFloat = 22
    }
    
    //MARK: - Public properties
    weak var delegate: ErrorViewDelegate?
    
    //MARK: - UI properties
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: UIConstants.errorLabelFontSize)
        label.text = "Oops!"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var errorDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: UIConstants.errorDescriptionLabelFontSize)
        label.text = "Something went wrong"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var errorImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "error")
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Try again", for: .normal)
        button.configuration = .borderedTinted()
        button.tintColor = UIColor(named: "lightGreenColor")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private functions
    private func setupView() {
        let vStack = UIStackView(arrangedSubviews: [errorLabel, errorDescriptionLabel, errorImageView, retryButton])
        vStack.axis = .vertical
        vStack.distribution = .equalSpacing
        vStack.alignment = .center
        vStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: self.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            errorImageView.widthAnchor.constraint(equalTo: vStack.widthAnchor, multiplier: 0.5),
            errorImageView.heightAnchor.constraint(equalTo: vStack.heightAnchor, multiplier: 0.6)
        ])
    }
    
    @objc func retryButtonTapped() {
        delegate?.didTryAgainButtonTapped()
    }
}
