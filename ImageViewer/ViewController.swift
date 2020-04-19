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
        vc = ImageViewerController.init(
            imageURLs: [
                getRandomImageURL(),
                getRandomImageURL(),
                getRandomImageURL(),
                getRandomImageURL()
            ],
            pageIndex: 2
        )
        
        view.addSubview(vc.view)
        vc.view.fill(in: view)
    }
}
