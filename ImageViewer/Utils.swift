//
//  Utils.swift
//  ImageViewer
//
//  Created by 阿久津　岳志 on 2020/04/16.
//  Copyright © 2020 阿久津　岳志. All rights reserved.
//

import UIKit

func getRandomImageURL() -> URL {
    let rand = Int(arc4random_uniform(1000))
    return URL(string: "https://picsum.photos/200/300?image=\(rand)")!
}

extension UIView {
    func fill(in superView: UIView, padding: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.topAnchor.constraint(equalTo: superView.topAnchor, constant: padding).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: padding).isActive = true
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: padding).isActive = true
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: padding).isActive = true
    }
}
