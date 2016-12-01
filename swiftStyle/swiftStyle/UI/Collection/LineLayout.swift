//
//  LineLayout.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/30/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import Darwin

class LineLayout: UICollectionViewFlowLayout {
    let activeDistance :CGFloat = 60
    let scaleFactor :CGFloat = 0.2
    
    override init() {
        super.init()
        self.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.minimumLineSpacing = 30
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalCenter = proposedContentOffset.x + self.collectionView!.bounds.width / 2.0
        
        //collectionView落在屏幕的大小
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: self.collectionView!.bounds.width, height: self.collectionView!.bounds.height)
        
        //获得落在屏幕的所有cell的属性
        let attributesArr = super.layoutAttributesForElements(in: targetRect)
        
        //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
        for layoutAttributes in attributesArr! {
            let itemHorizontalCenter = layoutAttributes.center.x;
            if (abs(itemHorizontalCenter - horizontalCenter) < abs(offsetAdjustment)) {
                offsetAdjustment = itemHorizontalCenter - horizontalCenter;
            }
        }
        //调整
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributesArr = super.layoutAttributesForElements(in: rect)
        let visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
        
        for attributes in attributesArr! {
            if attributes.frame.intersects(rect) {
                let distance = visibleRect.midX - attributes.center.x
                let normalizedDistance = distance / activeDistance
                
                if abs(distance) < activeDistance {
                    let zoom = 1 + scaleFactor * (1 - abs(normalizedDistance))
                    attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0)
                    attributes.zIndex = 1
                }
            }
        }
        
        return attributesArr
    }
    
    /**
     *  只要显示的边界发生改变就重新布局:
     内部会重新调用prepareLayout和layoutAttributesForElementsInRect方法获得所有cell的布局属性
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
