//
//  PhotoFeedHeaderView.swift
//  flickr-image-viewing
//
//  Created by MAC on 16.08.2022.
//

import UIKit

class PhotoFeedHeaderView: UICollectionReusableView {
    static let identifier = "HeaderCollectionReusableView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        label.textAlignment = .center
        label.textColor = UIColor(named: "color4")
        return label
    }()
    
    private let labelView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "color2")
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    public func configure(title: String) {
        
        label.text = title
        
        addSubview(labelView)
        labelView.addSubview(label)
        
        
        NSLayoutConstraint.activate([
            labelView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            labelView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            labelView.heightAnchor.constraint(equalToConstant: 70),
            labelView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)])
        
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalTo: labelView.heightAnchor),
            label.widthAnchor.constraint(equalTo: labelView.widthAnchor)])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = labelView.bounds
    }
}
