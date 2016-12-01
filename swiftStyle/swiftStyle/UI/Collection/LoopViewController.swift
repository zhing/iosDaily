//
//  LoopViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/29/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit

class LoopViewController: UIViewController {
    var collectionView :UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Loop"
        view.backgroundColor = UIColor.white
        setupViews()
    }

    func setupViews() {
        collectionView = {
            let lineLayout = LineLayout()
            lineLayout.sectionInset = UIEdgeInsetsMake(-30, 0, 30, 0)
            lineLayout.itemSize = CGSize(width: 120, height: 140)
            let cv = UICollectionView(frame: CGRect(x: 0, y: 64, width: ScreenWidth(), height: 200), collectionViewLayout: lineLayout)
            cv.backgroundColor = UIColor.white
            cv.dataSource = self
            cv.register(LoopCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
            view.addSubview(cv)
            return cv
        }()
    }
    
    lazy var images : [UIImage?] = {
        var imageArray = Array<UIImage?>()
        for index in 0...10 {
            imageArray.append(UIImage(named: "\(index).png"))
        }
        return imageArray
    }()
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LoopViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell :LoopCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! LoopCollectionViewCell
        cell.imageView.image = images[indexPath.row]
        cell.titleLabel.text = "图片\(indexPath.row)"
        
        return cell
    }
}
