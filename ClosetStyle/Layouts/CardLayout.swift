//
//  CardLayout.swift
//  ClosetStyle
//
//  Created by Wayne Mosley on 5/7/19.
//  Copyright © 2019 Wayne Mosley. All rights reserved.
//

import UIKit

class CardLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else {return}
        self.collectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        self.scrollDirection = .horizontal
        if collectionView.bounds.height > collectionView.bounds.width{
        itemSize = CGSize(width: 350, height: 490)
        }else{
           itemSize = CGSize(width: 375, height: 250)
        }
        minimumInteritemSpacing = 100
        minimumLineSpacing = 50
        
       let collectionInset = (collectionView.bounds.width - itemSize.width)/2
        self.sectionInset = UIEdgeInsets(top: 0, left: collectionInset, bottom: 0, right: collectionInset)
        
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView, let allAttributes = super.layoutAttributesForElements(in: rect) else {return [UICollectionViewLayoutAttributes]()}
        for attributes in allAttributes {
            let collectionCenter = collectionView.bounds.size.width / 2
            let offset = collectionView.contentOffset.x
            let normalizedCenter = attributes.center.x - offset
            
            let maxDistance = itemSize.width + minimumLineSpacing
            let distanceFromCenter = min(abs(collectionCenter - normalizedCenter), maxDistance)
            let ratio = (maxDistance - abs(distanceFromCenter)) / maxDistance
            _ = min(1, max(0, ratio))
            
            
        }
        return allAttributes
        
    }
    
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
       
        guard let collectionView = collectionView, let layoutAttributes = layoutAttributesForElements(in: collectionView.bounds) else {
            return .init(x: 0, y: 0)
        }
        // Snapping closest cell to the center
        let center = collectionView.bounds.size.width / 2
        let offsetWithCenter = proposedContentOffset.x + center
        let closestAttribute = layoutAttributes
            .sorted { abs($0.center.x - offsetWithCenter) < abs($1.center.x - offsetWithCenter) }
            .first ?? UICollectionViewLayoutAttributes()
        return CGPoint(x: closestAttribute.center.x - center, y: 0)
    }

}
