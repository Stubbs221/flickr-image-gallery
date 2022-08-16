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
            fullImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            fullImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            fullImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            fullImage.widthAnchor.constraint(equalToConstant: view.frame.size.width - 20),
            fullImage.heightAnchor.constraint(equalToConstant: view.frame.size.width - 20)
        ])
        
        NSLayoutConstraint.activate([
            dismissViewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dismissViewButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50)])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: fullImage.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)])
    }
}
