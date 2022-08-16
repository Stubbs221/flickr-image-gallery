//
//  FullImageView.swift
//  flickr-image-viewing
//
//  Created by MAC on 13.08.2022.
//

import UIKit
import Kingfisher

class FullImageView: UIViewController {
    
    var data: FlickrPhoto!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        guard let data = data else { return }
        print(data.largeImageURL)
        fullImage.kf.setImage(with: data.thumbnailURL)
    }
    
    lazy var fullImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 15
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()

    lazy var titleLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.setTitleColor(UIColor(named: "color2"), for: .normal)
        button.contentHorizontalAlignment = .left
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor(named: "color3")
        button.setTitle(data.title, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    lazy var dismissViewButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        button.configuration = configuration
        button.tintColor = UIColor(named: "color2")
        button.addTarget(self, action: #selector(dismissViewButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    @objc func dismissViewButtonPressed() {
        dismiss(animated: true)
    }
}

