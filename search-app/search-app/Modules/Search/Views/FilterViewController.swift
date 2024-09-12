//
//  FilterViewController.swift
//  search-app
//
//  Created by Evelina on 10.09.2024.
//

import Foundation
import UIKit

protocol FilterViewDelegate: AnyObject {
    func didFiltersChose(orderBy: OrderByFilter)
}

class FilterViewController: UIViewController {
    
    //MARK: - Private constants
    private enum UIConstants {
        static let contentInset: CGFloat = 16
        static let titleLabelFontSize: CGFloat = 16
        static let sortByFilterViewHeightMultiplier: CGFloat = 0.13
        static let applyButtonVerticalInsets: CGFloat = 10
        static let applyButtonHorizontalInsets: CGFloat = 20
    }
    
    //MARK: - Private properties
    private var orderBy: OrderByFilter
    
    //MARK: - Inits
    init(orderBy: OrderByFilter) {
        self.orderBy = orderBy
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI properties
    private lazy var applyFiltersButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = UIColor(named: "lightGreenColor")
        configuration.title = "Apply filters"
        configuration.contentInsets = NSDirectionalEdgeInsets(top: UIConstants.applyButtonVerticalInsets,
                                                              leading: UIConstants.applyButtonHorizontalInsets,
                                                              bottom: UIConstants.applyButtonVerticalInsets,
                                                              trailing: UIConstants.applyButtonHorizontalInsets)
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(applyFiltersButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sortByFilterView: FilterView = {
        let view = FilterView(filterTitle: "Sort by", 
                              selectionOptions: [OrderByFilter.relevant.text, OrderByFilter.latest.text],
                              selectedIndex: orderBy.rawValue)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Lifecycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    //MARK: - Private functions
    private func setupView() {
        navigationItem.title = "Filters"
        view.backgroundColor = UIColor(named: "backgroundColor")
        [sortByFilterView, applyFiltersButton].forEach({view.addSubview($0)})
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sortByFilterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.contentInset),
            sortByFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.contentInset),
            sortByFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.contentInset),
            sortByFilterView.heightAnchor.constraint(equalTo: view.heightAnchor, 
                                                     multiplier: UIConstants.sortByFilterViewHeightMultiplier),
            
            applyFiltersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -2 * UIConstants.contentInset),
            applyFiltersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    @objc func applyFiltersButtonTapped() {
        guard let stack = navigationController?.viewControllers else { return }
        guard let searchViewController = stack[stack.count - 2] as? SearchViewController else { return }
        searchViewController.orderBy = OrderByFilter(rawValue: sortByFilterView.selectedIndex) ?? .relevant
        navigationController?.popViewController(animated: true)
    }
    
}
