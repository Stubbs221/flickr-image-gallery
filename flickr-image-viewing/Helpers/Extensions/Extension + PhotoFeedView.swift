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
        view.addSubview(collectionView)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Find on Flickr"

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "color4")
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "color2")]
       
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        showSearchBarButton(shouldShow: true)
        
        
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    @objc func handleShowSearchBar() {
        search(shouldShow: true)
        searchBar.sizeToFit()
        searchBar.searchTextField.backgroundColor = UIColor(named: "color3")
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor(named: "color1")
        
        let clearButton = textFieldInsideUISearchBar?.value(forKey: "clearButton") as? UIButton
        let template = clearButton?.imageView?.image?.withRenderingMode(.alwaysTemplate)
        clearButton?.setImage(template, for: .normal)
        clearButton?.tintColor = UIColor(named: "color4")
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

// MARK: UICollectionViewDataSource

extension PhotoFeedView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoFeedCell else { return UICollectionViewCell() }
        let flickrPhoto = self.photo(for: indexPath)
        cell.imageView.kf.setImage(with: flickrPhoto.thumbnailURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoFeedHeaderView.identifier, for: indexPath) as? PhotoFeedHeaderView else { return UICollectionReusableView() }
        header.configure(title: searches[indexPath.section].searchTerm)
        
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 90)
    }
}

// MARK: UICollectionViewDelegate

extension PhotoFeedView: UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as? PhotoFeedCell
        selectedCellImageViewSnapshot = selectedCell?.imageView.snapshotView(afterScreenUpdates: false)
        presentSecondVC(with: photo(for: indexPath))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1 )
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
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
