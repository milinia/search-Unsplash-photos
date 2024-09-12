//
//  FilterView.swift
//  search-app
//
//  Created by Evelina on 11.09.2024.
//

import Foundation
import UIKit

class FilterView: UIView {
    
    //MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let titleLabelFontSize: CGFloat = 16
        static let hStackSpacing: CGFloat = 10
        static let checkBoxWidth: CGFloat = 25
        static let filterTitleLabelNumberOfLines: Int = 1
        static let lineTopInset: CGFloat = 3
        static let lineHeight: CGFloat = 1
        static let contentViewTopInset: CGFloat = 10
    }
    
    //MARK: - Private properties
    private let filterTitle: String
    private let selectionOptions: [String]
    private var stackArray: [UIStackView] = []
    
    //MARK: - Public properties
    var selectedIndex: Int
    
    //MARK: - UI properties
    private lazy var filterTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = UIConstants.filterTitleLabelNumberOfLines
        label.font = .boldSystemFont(ofSize: UIConstants.titleLabelFontSize)
        label.text = filterTitle
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Init
    init(filterTitle: String, selectionOptions: [String], selectedIndex: Int) {
        self.filterTitle = filterTitle
        self.selectionOptions = selectionOptions
        self.selectedIndex = selectedIndex
        super.init(frame: CGRect())
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private functions
    private func setupView() {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .systemGray4
        
        [filterTitleLabel, line, contentView].forEach({addSubview($0)})
        
        NSLayoutConstraint.activate([
            filterTitleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            filterTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            line.topAnchor.constraint(equalTo: filterTitleLabel.bottomAnchor,
                                      constant: UIConstants.lineTopInset),
            line.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            line.heightAnchor.constraint(equalToConstant: UIConstants.lineHeight),
            
            contentView.topAnchor.constraint(equalTo: line.bottomAnchor,
                                             constant: UIConstants.contentViewTopInset),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        var index = 0
        selectionOptions.forEach({ option in
            let checkBox = CheckBox()
            checkBox.translatesAutoresizingMaskIntoConstraints = false
            let label = UILabel()
            label.text = option
            label.translatesAutoresizingMaskIntoConstraints = false
            
            if index == selectedIndex {
                checkBox.check()
            }
            
            let hStack = UIStackView(arrangedSubviews: [checkBox, label])
            hStack.axis = .horizontal
            hStack.distribution = .fillProportionally
            hStack.alignment = .fill
            hStack.spacing = UIConstants.hStackSpacing
            hStack.translatesAutoresizingMaskIntoConstraints = false
            contentView.addArrangedSubview(hStack)
            NSLayoutConstraint.activate([
                hStack.widthAnchor.constraint(equalTo: contentView.widthAnchor),
                checkBox.widthAnchor.constraint(equalToConstant: UIConstants.checkBoxWidth)
            ])
            
            label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            checkBox.setContentHuggingPriority(.required, for: .horizontal)

            label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            checkBox.setContentCompressionResistancePriority(.required, for: .horizontal)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(optionTapped(_:)))
            hStack.addGestureRecognizer(tapGesture)
            hStack.isUserInteractionEnabled = true
            hStack.tag = index
            index += 1
            stackArray.append(hStack)
        })
    }
    
    @objc func optionTapped(_ sender: UITapGestureRecognizer) {
        if let tappedStack = sender.view as? UIStackView {
            let subviews = tappedStack.subviews
            let index = tappedStack.tag
            guard let checkBox = subviews.first as? CheckBox else { return }
            if !checkBox.isCheck {
                checkBox.check()
                uncheckView(index: selectedIndex)
                selectedIndex = index
            }
        }
    }
    
    private func uncheckView(index: Int) {
        let stackView = stackArray[index]
        let subviews = stackView.subviews
        guard let checkBox = subviews.first as? CheckBox else { return }
        checkBox.uncheck()
    }
}
