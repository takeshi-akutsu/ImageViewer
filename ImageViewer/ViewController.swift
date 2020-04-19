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
    
    @IBOutlet weak var totalPageCountLabel: UILabel!
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
        
        totalPageCountLabel.text = "全部で \(imageURLs.count) 枚の画像がある"
        startIndex = Int.random(in: 0..<imageURLs.count)
        startIndexLabel.text = "最初に表示するのは \(startIndex + 1) ページ目"
        lastIndexLabel.text = "最後に閲覧したのは ?? ページ目"
    }
    
    @IBAction func showImageViewer(_ sender: UIButton) {
        let vc = ImageViewerController.init(imageURLs: imageURLs, pageIndex: startIndex)
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension ViewController: ImageViewerControllerDelegate {
    func dismiss(_ imageViewerController: ImageViewerController, lastPageIndex: Int) {
        lastIndexLabel.text = "最後に閲覧したのは \(lastPageIndex + 1) ページ目"
    }
}
