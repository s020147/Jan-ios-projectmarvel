// -------------------------------------------------------------------------
// This item is the property of ResMed Ltd, and contains confidential and trade
// secret information. It may not be transferred from the custody or control of
// ResMed except as authorized in writing by an officer of ResMed. Neither this
// item nor the information it contains may be used, transferred, reproduced,
// published, or disclosed, in whole or in part, and directly or indirectly,
// except as expressly authorized by an officer of ResMed, pursuant to written
// agreement.
//
// Copyright (c) 2022 ResMed Ltd.  All rights reserved.
// -------------------------------------------------------------------------


import UIKit
import SwiftUI

private let reuseIdentifier = "collectioncell"

class MarvelCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    func handle(error: Error) {
        
    }
    
    var searchDebounceTimer: Timer?

    var searchBar = SearchCollectionReusableView().searchBar
    var searchText: String = ""
    var viewModel = CharacterEventViewModel(serviceManager: CharacterService())
    var searchActive:Bool = false
    var isLoading = false
    var loadingView: CollectionReusableView?
    
    private let backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = backgroundColor
        
        let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
        guard let key = apiKey, !key.isEmpty else {
            print("API key does not exist")
            return
        }
        print("REST API key:", key)
        
        viewModel.getAllCharacters { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        } onFailure: { error in
            self.handleError()
            print("Error has occured: \(error)")
        }
        
        setupSearch()
        
        let loadingReusableNib = UINib(nibName: "CollectionReusableView", bundle: nil)
        collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingreusableviewid")
        collectionView.register(LoadingReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingReusableView")
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = backgroundColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        appearance.titleTextAttributes = textAttributes
        
        navigationController?.navigationBar.tintColor = .black
        
        // setting navigation bar
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.clipsToBounds = true
        let title = UILabel()
        title.text = "Superhero Directory"
        title.font = UIFont.boldSystemFont(ofSize: 14.0)
        let titleView = UIStackView(arrangedSubviews: [imageView, title])
        titleView.axis = .vertical
        titleView.spacing = 10.0
        titleView.clipsToBounds = true
        titleView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            imageView.topAnchor.constraint(equalTo: titleView.topAnchor, constant: -3),
            imageView.leftAnchor.constraint(equalTo: titleView.leftAnchor),
            imageView.bottomAnchor.constraint(equalTo: title.topAnchor),
            title.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            imageView.rightAnchor.constraint(equalTo: titleView.rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        self.navigationItem.titleView = titleView
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        guard contentHeight > 0 else {return}
        
        if scrollView.isScrolledToBottom() {
            loadMoreData()
        }
    }
    
    @objc private func didPullToRefresh() {
        self.viewModel.getAllCharacters { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.collectionView.refreshControl?.endRefreshing()
                print("data reloaded")
            }
        } onFailure: { error in
            self.handleError()
            print("Error has occured: \(error)")
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumOfCharacters(searchIsActive: searchActive)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CharacterCollectionViewCell else {
            assertionFailure("could not unwrap cell")
            return UICollectionViewCell()
        }
        cell.nameLabel.text = viewModel.getName(for: indexPath, searchIsActive: searchActive)
        cell.imageURL = viewModel.getCharacterImageURL(for: indexPath, isSearchActive: searchActive)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageURL = viewModel.getCharacterImageURL(for: indexPath, isSearchActive: searchActive)
        let character = viewModel.getCharacter(for: indexPath, searchIsActive: searchActive)!
        print(character)
        let detailView = DetailView(character: character, imageURL: imageURL!)
        let hostingController = DetailsHostingViewController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

extension MarvelCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.bounds.size.width
        let width = availableWidth/2 - 25
        let height = width*1.15
        return CGSize(width: width, height: height)
    }
    
    //MARK: - Search and UICollectionReusableView
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            return UICollectionReusableView()
        }
        if let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingReusableView", for: indexPath) as? LoadingReusableView {
            return footerView
        }

        return UICollectionReusableView()
    }

    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            viewModel.getNextCharacters(searchText: searchText,isSearchActive: searchActive) {
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                    self?.isLoading = false
                    print("reloadData called")
                }
            }
        }
    }
    
    func handleError() {
        let alert = UIAlertController(title: "Alert", message: "Unexpected error occured", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
    
}

extension MarvelCollectionViewController: UISearchResultsUpdating {
    func setupSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search"
        navigationItem.searchController = search
    }
    
    fileprivate func searchFilteredResult(_ text: String) {
        searchActive = true
        viewModel.filterNames(text) { [weak self] in
            self?.viewModel.filtered = self?.viewModel.filtered ?? []
            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        } onFailure: { error in
            self.handleError()
            print("Error has occured: \(error)")
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            searchDebounceTimer?.invalidate()

            guard let text = searchController.searchBar.text else { return }
            
            searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                self?.searchFilteredResult(text)
            })
        } else {
            searchActive = false
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
        }
    }
}



extension UIScrollView {
    func isScrolledToBottom(threshold: CGFloat = 50) -> Bool {
        let contentHeight = self.contentSize.height

        guard contentHeight > 0 else { return false }

        let offsetY = self.contentOffset.y
        let height = self.frame.size.height

        return offsetY > contentHeight - height - threshold
    }
}
