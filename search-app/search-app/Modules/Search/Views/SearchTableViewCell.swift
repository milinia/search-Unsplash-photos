//
//  SearchTableViewCell.swift
//  search-app
//
//  Created by Evelina on 09.09.2024.
//

import Foundation
import UIKit

final class SearchTableViewCell: UITableViewCell {
    
    //MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 6
        static let searchLabelFontSize: CGFloat = 16
        static let hStackSpacing: CGFloat = 10
        static let searchLabelNumberOfLines: Int = 1
    }

    // MARK: - Private UI properties
    private lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = UIConstants.searchLabelNumberOfLines
        label.font = .systemFont(ofSize: UIConstants.searchLabelFontSize)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var clockImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "clock.arrow.circlepath")
        image.tintColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private functions
    private func initialize() {
        backgroundColor = .clear
        
        let hStack = UIStackView(arrangedSubviews: [clockImageView, searchLabel])
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.spacing = UIConstants.hStackSpacing
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.contentInset),
            hStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -UIConstants.contentInset),
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIConstants.contentInset),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIConstants.contentInset),
        ])
        searchLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        clockImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    // MARK: - Public functions
    func setSearchText(searchText: String) {
        searchLabel.text = searchText
    }
}
