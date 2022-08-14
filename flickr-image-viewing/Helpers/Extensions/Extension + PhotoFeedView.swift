//
//  Extension PhotoFeedController.swift
//  flickr-image-viewing
//
//  Created by MAC on 09.08.2022.
//

import Foundation
import UIKit

extension PhotoFeedView {
    func setupUI() {
          
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Search Bar"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBlue
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
       
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        showSearchBarButton(shouldShow: true)
    }
    
    @objc func handleShowSearchBar() {
        search(shouldShow: true)
        searchBar.sizeToFit()
        searchBar.searchTextField.backgroundColor = .white
        
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
    }
    
    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                target: self,
                                                                action: #selector(handleShowSearchBar))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }
    
    func photo(for indexPath: IndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
}

extension PhotoFeedView: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Search bar text did begin editing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Search bar text did end editing")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text is \(searchText)")
    }
}

extension PhotoFeedView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return true }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        
        NetworkService.searchFlickr(for: text) { [ weak self ] searchResults in
            DispatchQueue.main.async {
                activityIndicator.removeFromSuperview()
                switch searchResults {
                case .failure(let error) :
                    print("Error searching: \(error)")
                case .success(let results):
                    print("Found \(results.searchResults.count)   / matching \(results.searchTerm)")
                    self?.searches.insert(results, at: 0)
                    self?.collectionView.reloadData()
                }
            }
        }
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}

extension PhotoFeedView {
    func presentSecondVC(with data: FlickrPhoto) {
        let secondVC = FullImageView()
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.data = data
        present(secondVC, animated: true)
    }
}
