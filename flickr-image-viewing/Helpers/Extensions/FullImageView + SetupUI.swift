//
//  FullImageView.swift
//  flickr-image-viewing
//
//  Created by MAC on 14.08.2022.
//

import UIKit

extension FullImageView {
    func setupUI() {
        view.backgroundColor = UIColor(named: "color4")
        view.addSubview(fullImage)
        view.addSubview(dismissViewButton)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            fullImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fullImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            fullImage.heightAnchor.constraint(equalToConstant: 300),
            fullImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dismissViewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            dismissViewButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: fullImage.bottomAnchor, constant: 85),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)])
    }
}
