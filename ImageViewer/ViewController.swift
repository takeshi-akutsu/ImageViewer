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
    
    @IBOutlet weak var startIndexLabel: UILabel!
    @IBOutlet weak var lastIndexLabel: UILabel!
    
    private let imageURLs: [URL] = [
        getRandomImageURL(),
        getRandomImageURL(),
        getRandomImageURL(),
        getRandomImageURL(),
        getRandomImageURL()
    ]
    private var startIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startIndex = Int.random(in: 0..<imageURLs.count)
        startIndexLabel.text = "initial page's gonna be \(startIndex)"
    }
    
    @IBAction func showImageViewer(_ sender: UIButton) {
        let vc = ImageViewerController.init(imageURLs: imageURLs, pageIndex: startIndex)
        present(vc, animated: true)
    }
}
