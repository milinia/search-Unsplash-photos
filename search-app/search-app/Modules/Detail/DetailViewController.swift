//
//  DetailViewController.swift
//  search-app
//
//  Created by Evelina on 11.09.2024.
//

import Foundation
import UIKit

protocol DetailViewProtocol: BaseView, AnyObject {
    func updateViews(photoData: PhotoData)
    func showAlert(error: Error?)
}

class DetailViewController: UIViewController {
    
    //MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let titleLabelFontSize: CGFloat = 16
        static let infoStackViewSpacing: CGFloat = 10
        static let authorViewHeight: CGFloat = 40
        static let descriptionLabelFontSize: CGFloat = 18
    }
    
    //MARK: - Private properties
    private let presenter: DetailPresenterProtocol
    private let id: String
    
    //MARK: - Inits
    init(id: String, presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI properties
    private lazy var mediaImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var authorView: AuthorView = {
        let view = AuthorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = UIConstants.infoStackViewSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: UIConstants.descriptionLabelFontSize)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var errorView: ErrorView = {
        let view = ErrorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    private lazy var downloadButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Download", style: .plain, target: self, action: #selector(downloadButtonTapped))
        button.tintColor = .black
        return button
    }()
    
    @objc func downloadButtonTapped() {
        if let image = mediaImageView.image {
            presenter.saveImageToGallary(image: image)
        }
    }
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
       }()

    //MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.getPhotoData(id: id)
        setupView()
    }
    
    //MARK: - Private functions
    private func setupView() {
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        [authorView, mediaImageView, infoStackView].forEach({contentView.addSubview($0)})
        [errorView, loadingView, contentView].forEach({view.addSubview($0)})
        setupConstraints()
        navigationItem.rightBarButtonItem = downloadButton
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.widthAnchor.constraint(equalTo: view.widthAnchor),
            errorView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.contentInset),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.contentInset),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.contentInset),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -UIConstants.contentInset),
            
            
            authorView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            authorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            authorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            authorView.heightAnchor.constraint(equalToConstant: UIConstants.authorViewHeight),
            
            mediaImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            mediaImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mediaImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            mediaImageView.topAnchor.constraint(equalTo: authorView.bottomAnchor, constant: UIConstants.contentInset),
           
            infoStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoStackView.topAnchor.constraint(equalTo: mediaImageView.bottomAnchor, constant: UIConstants.contentInset),
            infoStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
        ])
        authorView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        mediaImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        infoStackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

extension DetailViewController: DetailViewProtocol {
    
    func showError() {
        DispatchQueue.main.async {
            self.errorView.isHidden = false
            self.loadingView.isHidden = true
            self.contentView.isHidden = true
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.errorView.isHidden = true
            self.loadingView.isHidden = false
            self.contentView.isHidden = true
            self.loadingView.startAnimating()
        }
    }
    
    func showContent() {
        DispatchQueue.main.async {
            self.errorView.isHidden = true
            self.loadingView.isHidden = true
            self.contentView.isHidden = false
        }
    }
    
    func updateViews(photoData: PhotoData) {
        showContent()
        DispatchQueue.main.async {
            
            if let description = photoData.responseData.description {
                self.descriptionLabel.text = description
                self.infoStackView.addArrangedSubview(self.descriptionLabel)
                self.infoStackView.setCustomSpacing(UIConstants.contentInset, after: self.descriptionLabel)
            }
            
            let dateInfoView = InfoView()
            dateInfoView.setData(image: UIImage(systemName: "calendar"), text: "Published on \(photoData.date)")
            self.infoStackView.addArrangedSubview(dateInfoView)
            
            if let location = photoData.responseData.location {
                if (location.city != nil) || (location.country != nil) {
                    var text = ""
                    if let city = location.city {
                        text += city
                    }
                            
                    if let country = location.country {
                        if !text.isEmpty {
                            text += ", "
                        }
                        text += country
                    }
                    let locationInfoView = InfoView()
                    locationInfoView.setData(image: UIImage(systemName: "mappin"),
                                         text: text)
                    self.infoStackView.addArrangedSubview(locationInfoView)
                    
                }
            }
            if let exif = photoData.responseData.exif, let name = exif.name {
                let exifInfoView = InfoView()
                exifInfoView.setData(image: UIImage(systemName: "camera"),
                                     text: name)
                self.infoStackView.addArrangedSubview(exifInfoView)
            }
            if photoData.responseData.likes > 0 {
                let likesInfoView = InfoView()
                let likeText = photoData.responseData.likes > 1 ? "likes" : "like"
                likesInfoView.setData(image: UIImage(systemName: "heart"),
                                      text: "\(photoData.responseData.likes) \(likeText)")
                self.infoStackView.addArrangedSubview(likesInfoView)
                
            }
            if photoData.responseData.downloads > 0 {
                let downloadsInfoView = InfoView()
                let downloadText = photoData.responseData.likes > 1 ? "downloads" : "download"
                downloadsInfoView.setData(image: UIImage(systemName: "arrow.down.square"),
                                      text: "\(photoData.responseData.downloads) \(downloadText)")
                self.infoStackView.addArrangedSubview(downloadsInfoView)
            }
            
            self.authorView.setAuthorData(image: photoData.authorImage,
                                     name: photoData.responseData.user.name,
                                     username: photoData.responseData.user.username)
            self.mediaImageView.image = photoData.image
            
            let emptyView = UIView()
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            self.infoStackView.addArrangedSubview(emptyView)
            emptyView.setContentHuggingPriority(.defaultLow, for: .vertical)
        }
    }
    
    func showAlert(error: Error?) {
        let message = error == nil ? "Image saved" : "Error"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension DetailViewController: ErrorViewDelegate {
    func didTryAgainButtonTapped() {
        presenter.getPhotoData(id: id)
    }
}
