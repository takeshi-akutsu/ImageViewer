//
//  ViewController.swift
//  ImageViewer
//
//  Created by 阿久津　岳志 on 2020/04/16.
//  Copyright © 2020 阿久津　岳志. All rights reserved.
//

import UIKit

func uninitialized<T>() -> T { fatalError() }

class ViewController: UIViewController {
    
    lazy var vc: ImageViewerController = uninitialized()

    override func viewDidLoad() {
        super.viewDidLoad()
        vc = ImageViewerController.init(images: images)
        view.addSubview(vc.view)
        vc.view.fill(in: view)
    }
}

private let images: [UIImage] = [
    UIImage.init(named: "sample")!,
    UIImage.init(named: "sample2")!,
    UIImage.init(named: "sample")!,
]
