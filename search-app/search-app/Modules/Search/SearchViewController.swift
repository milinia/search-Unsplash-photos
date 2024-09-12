//
//  SearchViewController.swift
//  search-app
//
//  Created by Evelina on 09.09.2024.
//

import Foundation
import UIKit

protocol SearchViewProtocol: BaseView, AnyObject {
    func showSearchResult()
    func showSearchHistory()
    func updateSearchResult()
}

final class SearchViewController: UIViewController {
    
    //MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let titleLabelFontSize: CGFloat = 16
        static let searchResultTitleLabelNumberOfLines: Int = 1
        static let hStackSpacing: CGFloat = 10
    }
    
    //MARK: - Private properties
    private var presenter: SearchPresenterProtocol
    private var searchResultLayout: SearchResultLayout = .twoColumns {
        didSet {
            searchResultLayoutButton.setImage(UIImage(systemName: searchResultLayout.imageName),
                                              for: .normal)
            layout.numberOfColumns = searchResultLayout.rawValue + 1
        }
    }
    //MARK: - Public properties
    var orderBy: OrderByFilter = .relevant
    
    //MARK: - UI properties
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .alphabet
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.delegate = self
        return textField
    }()
    
    private lazy var filterButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: "slider.horizontal.3")
        configuration.baseBackgroundColor = UIColor(named: "lightGreenColor")
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchResultLayoutButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: searchResultLayout.imageName), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(searchResultLayoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchResultTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = UIConstants.searchResultTitleLabelNumberOfLines
        label.font = .boldSystemFont(ofSize: UIConstants.titleLabelFontSize)
        label.text = "Search result"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentViewForSearchResult: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var layout: PhotoCollectionLayout = {
        let layout = PhotoCollectionLayout()
        layout.numberOfColumns = searchResultLayout.rawValue + 1
        layout.delegate = self
        return layout
    }()
    
    private lazy var searchResultsCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.register(SearchResultCollectionViewCell.self,
                            forCellWithReuseIdentifier: String(describing: SearchResultCollectionViewCell.self))
        return collection
    }()
    
    private lazy var searchHistoryView: SearchHistoryView = {
        let view = SearchHistoryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
       }()
    
    //MARK: - Inits
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        showContent()
        presenter.fetchSearchHistory()
    }
    
    //MARK: - Private functions
    private func setupView() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        navigationItem.backButtonTitle = ""
        setupContraints()
    }
    
    private func setupContraints() {
        let hStack = UIStackView(arrangedSubviews: [searchTextField, filterButton])
        hStack.axis = .horizontal
        hStack.distribution = .fillProportionally
        hStack.spacing = UIConstants.hStackSpacing
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        let hStackForViewButton = UIStackView(arrangedSubviews: [searchResultTitleLabel, searchResultLayoutButton])
        hStackForViewButton.axis = .horizontal
        hStackForViewButton.distribution = .fill
        hStackForViewButton.spacing = UIConstants.hStackSpacing
        hStackForViewButton.translatesAutoresizingMaskIntoConstraints = false
        [loadingView, errorView, searchHistoryView,
         contentViewForSearchResult].forEach({contentView.addSubview($0)})
        [hStackForViewButton, searchResultsCollectionView].forEach({contentViewForSearchResult.addSubview($0)})
        [hStack, contentView].forEach({view.addSubview($0)})
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.contentInset),
            hStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UIConstants.contentInset),
            hStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
            
            filterButton.widthAnchor.constraint(equalTo: hStack.widthAnchor, multiplier: 0.15),
            
            contentView.topAnchor.constraint(equalTo: hStack.bottomAnchor, constant: UIConstants.contentInset),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: UIConstants.contentInset),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -UIConstants.contentInset),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.contentInset),
            
            loadingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            errorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            errorView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            errorView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            searchHistoryView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            searchHistoryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            searchHistoryView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            searchHistoryView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            contentViewForSearchResult.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentViewForSearchResult.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentViewForSearchResult.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentViewForSearchResult.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            hStackForViewButton.leadingAnchor.constraint(equalTo: contentViewForSearchResult.leadingAnchor),
            hStackForViewButton.trailingAnchor.constraint(equalTo: contentViewForSearchResult.trailingAnchor),
            hStackForViewButton.topAnchor.constraint(equalTo: contentViewForSearchResult.topAnchor),
            hStackForViewButton.heightAnchor.constraint(equalTo: contentViewForSearchResult.heightAnchor, multiplier: 0.05),
            
            searchResultsCollectionView.topAnchor.constraint(equalTo: hStackForViewButton.bottomAnchor, constant: 10),
            searchResultsCollectionView.leadingAnchor.constraint(equalTo: contentViewForSearchResult.leadingAnchor),
            searchResultsCollectionView.trailingAnchor.constraint(equalTo: contentViewForSearchResult.trailingAnchor),
            searchResultsCollectionView.bottomAnchor.constraint(equalTo: contentViewForSearchResult.bottomAnchor)
        ])
        searchResultTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        searchResultLayoutButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
    }
    
    @objc func filterButtonTapped() {
        let filterViewController = FilterViewController(orderBy: orderBy)
        navigationController?.pushViewController(filterViewController, animated: true)
    }
    
    @objc func searchResultLayoutButtonTapped() {
        searchResultLayout = searchResultLayout == .oneColumn ? .twoColumns : .oneColumn
        searchResultsCollectionView.reloadData()
        searchResultsCollectionView.collectionViewLayout.invalidateLayout()
    }
}

extension SearchViewController: SearchViewProtocol {
    
    func showError() {
        DispatchQueue.main.async {
            self.errorView.isHidden = false
            self.loadingView.isHidden = true
            self.searchHistoryView.isHidden = true
            self.contentViewForSearchResult.isHidden = true
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            self.errorView.isHidden = true
            self.searchHistoryView.isHidden = true
            self.contentViewForSearchResult.isHidden = true
            self.loadingView.startAnimating()
        }
    }
    
    func showContent() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.errorView.isHidden = true
            self.searchHistoryView.isHidden = true
            self.contentViewForSearchResult.isHidden = true
        }
    }
    
    func showSearchResult() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.errorView.isHidden = true
            self.searchHistoryView.isHidden = true
            self.contentViewForSearchResult.isHidden = false
            self.searchResultsCollectionView.reloadData()
        }
    }
    
    func showSearchHistory() {
        showContent()
        DispatchQueue.main.async {
            self.searchHistoryView.isHidden = false
            self.searchHistoryView.searches = self.presenter.getSearchHistory()
        }
    }
    
    func updateSearchResult() {
        DispatchQueue.main.async {
            self.searchResultsCollectionView.reloadData()
        }
    }
}

extension SearchViewController: ErrorViewDelegate {
    func didTryAgainButtonTapped() {
        
    }
}

extension SearchViewController: SearchHistoryViewDelegate {
    
    func didTapOnSearchRequest(index: Int) {
        presenter.makeSearchRequestFromHistory(index: index,
                                               orderBy: orderBy)
        searchTextField.text = presenter.getSearchHistory()[index]
    }
    
    func didTapClearHistoryButton() {
        presenter.clearSearchHistory()
        searchHistoryView.isHidden = true
    }
    
    func makeView(isHidden: Bool) {
        searchHistoryView.isHidden = isHidden
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        layout.recalculate()
        presenter.makeFirstSearchRequest(request: textField.text, orderBy: orderBy)
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if searchResultsCollectionView.isHidden {
            let currentText = textField.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
            searchHistoryView.filterSearchRequest(text: newText)
        }
        return true
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getPhotos().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SearchResultCollectionViewCell.self), for: indexPath) as? SearchResultCollectionViewCell else {return UICollectionViewCell()}
        let photo = presenter.getPhotos()[indexPath.row]
        presenter.downloadImage(imageURL: photo.urls.regular) { image, imageURL in
            if imageURL == photo.urls.regular {
                DispatchQueue.main.async {
                    cell.setImage(image: image)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == presenter.getPhotos().count - 1 {
            presenter.makeSearchRequestByPage(request: searchTextField.text,
                                              orderBy: orderBy)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.openDetailView(index: indexPath.row)
    }
}

// MARK: - Implementation PhotoCollectionLayoutDelegate
extension SearchViewController: PhotoCollectionLayoutDelegate {
   
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let width = presenter.sizes[indexPath.item].0
        let height = presenter.sizes[indexPath.item].1
        let aspectRatio = CGFloat(height) / CGFloat(width)
        let divider: CGFloat = searchResultLayout == .oneColumn ? 1 : 2
        let itemWidth = (collectionView.bounds.width - UIConstants.contentInset) / divider
        let itemHeight = itemWidth * aspectRatio
        return itemHeight
    }
}
