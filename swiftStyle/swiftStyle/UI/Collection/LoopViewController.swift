//
//  LoopViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/29/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import SDCycleScrollView

class LoopViewController: UIViewController {
    var collectionView :UICollectionView!
    var cycleScrollView1 :SDCycleScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Loop"
        view.backgroundColor = UIColor.white
        setupViews()
    }

    func setupViews() {
        collectionView = {
            let lineLayout = LineLayout()
            lineLayout.sectionInset = UIEdgeInsetsMake(-30, 10, 30, 10)
            lineLayout.itemSize = CGSize(width: 120, height: 140)
            let cv = UICollectionView(frame: CGRect(x: 0, y: 64, width: ScreenWidth(), height: 200), collectionViewLayout: lineLayout)
            cv.backgroundColor = UIColor.white
            cv.dataSource = self
            cv.register(LoopCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
            view.addSubview(cv)
            return cv
        }()
        
        cycleScrollView1 = {
            let cv = SDCycleScrollView(frame: CGRect.init(x: 0, y: 280, width: ScreenWidth(), height: 200), delegate: nil, placeholderImage: nil)!
            cv.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
            cv.currentPageDotColor = UIColor.white
            cv.autoScrollTimeInterval = 2.0
            view.addSubview(cv)
            
            return cv
        }()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cycleScrollView1.imageURLStringsGroup = imagesURLStrings;
    }
    
    lazy var images : [UIImage?] = {
        var imageArray = Array<UIImage?>()
        for index in 0...10 {
            imageArray.append(UIImage(named: "\(index).png"))
        }
        return imageArray
    }()
    
    lazy var imagesURLStrings :[String] = {
        return ["https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
             "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
              "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"]
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
