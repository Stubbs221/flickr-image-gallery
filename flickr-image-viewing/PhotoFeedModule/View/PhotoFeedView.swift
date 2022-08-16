//
//  CollectionViewController.swift
//  flickr-image-viewing
//
//  Created by MAC on 10.08.2022.
//

import UIKit



class PhotoFeedView: UIViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    let searchBar = UISearchBar()
    let reuseIdentifier = "FlickrCell"
    let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 50, right: 20)
    
    var searches: [FlickrSearchResults] = []
    var flickr = Flickr()
    let itemsPerRow: CGFloat = 2
    let group = DispatchGroup()
    let queue1 = DispatchQueue.global(qos: .userInteractive)
    
    var selectedCell: PhotoFeedCell?
    var selectedCellImageViewSnapshot: UIView?
    var animator: Animator?
    
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = sectionInsets
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height), collectionViewLayout: layout)
        collectionView.register(PhotoFeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(PhotoFeedHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoFeedHeaderView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "color1")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    @objc func reloadButtonPressed() {
        collectionView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */


  
}
