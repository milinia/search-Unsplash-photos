//
//  SearchHistoryView.swift
//  search-app
//
//  Created by Evelina on 09.09.2024.
//

import Foundation
import UIKit

protocol SearchHistoryViewDelegate: AnyObject {
    func didTapClearHistoryButton()
    func didTapOnSearchRequest(index: Int)
    func makeView(isHidden: Bool)
}

class SearchHistoryView: UIView {
    
    //MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let titleLabelFontSize: CGFloat = 16
        static let smallContentInset: CGFloat = 6
        static let hStackHeightMultiplier: CGFloat = 0.08
    }
    
    //MARK: - Public properties
    var searches: [String] = [] {
        didSet {
            searchesTableView.reloadData()
        }
    }
    
    private var filteredSearches: [String] = []
    private var isFiltering: Bool = false
    
    weak var delegate: SearchHistoryViewDelegate?
    
    //MARK: - UI properties
    private lazy var resentSearchesTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: UIConstants.titleLabelFontSize)
        label.text = "Resent searches"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var clearHistoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(UIColor(named: "lightGreenColor"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchesTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: String(describing: SearchTableViewCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        return tableView
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
        let hStack = UIStackView(arrangedSubviews: [resentSearchesTitleLabel, clearHistoryButton])
        hStack.axis = .horizontal
        hStack.distribution = .fill
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        [hStack, searchesTableView].forEach({addSubview($0)})
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: self.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            hStack.heightAnchor.constraint(equalTo: self.heightAnchor, 
                                           multiplier: UIConstants.hStackHeightMultiplier),
        
            searchesTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchesTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            searchesTableView.topAnchor.constraint(equalTo: hStack.bottomAnchor,
                                                   constant: UIConstants.smallContentInset),
            searchesTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        resentSearchesTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        clearHistoryButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    @objc func clearButtonTapped() {
        delegate?.didTapClearHistoryButton()
    }
    
    //MARK: - Public functions
    func filterSearchRequest(text: String?) {
        guard let text = text else { return }
        isFiltering = true
        filteredSearches = searches.filter { $0.localizedCaseInsensitiveContains(text) }
        if filteredSearches.isEmpty && text != "" {
            delegate?.makeView(isHidden: true)
        } else {
            if text == "" {
                isFiltering = false
            }
            delegate?.makeView(isHidden: false)
            searchesTableView.reloadData()
        }
    }
}

extension SearchHistoryView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredSearches.count : searches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SearchTableViewCell.self), for: indexPath) as? SearchTableViewCell else {return UITableViewCell()}
        let text = isFiltering ? filteredSearches[indexPath.row] : searches[indexPath.row]
        cell.setSearchText(searchText: text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapOnSearchRequest(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
