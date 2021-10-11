//
//  WeatherCollectionViewCompositionalLayout.swift
//  Weather
//
//  Created by Andrei Kornilov on 04.10.2021.
//

import UIKit

final class WeatherCollectionViewCompositionalLayout: UICollectionViewCompositionalLayout {
    var attributes: [UICollectionViewLayoutAttributes] = []
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
        
    override func prepare() {
        super.prepare()
        
        attributes = []
        guard let collectionView = collectionView else { return }
        
        
        let numberOfSections = collectionView.numberOfSections
        for section in 0..<numberOfSections {
            let headerIndexPath = IndexPath(item: 0, section: section)
            
            if let headerAttribute = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: headerIndexPath)?.copy() {
                attributes.append(headerAttribute as! UICollectionViewLayoutAttributes)
            }
            
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            for item in 0..<numberOfItems {
                let indexPath = IndexPath(item: item, section: section)
                
                if let attribute = layoutAttributesForItem(at: indexPath)?.copy() {
                    attributes.append(attribute as! UICollectionViewLayoutAttributes)
                }
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let offset = collectionView?.contentOffset ?? CGPoint.zero

        let headers = attributes.filter { attribute -> Bool in
            return attribute.representedElementKind == UICollectionView.elementKindSectionHeader
        }
        
        guard let topHeader = headers.first, let secondHeader = headers.last else { return nil }

        let topHeaderDefaultSize = topHeader.frame.size
        topHeader.frame.size.height = max(Constant.minHeightForTopHeader, topHeaderDefaultSize.height - offset.y)
        topHeader.frame.origin.y = offset.y

        secondHeader.frame.origin.y = topHeader.frame.origin.y + topHeader.frame.size.height

        let cells = attributes.filter { (attribute) -> Bool in
            return (attribute.representedElementKind != UICollectionView.elementKindSectionHeader) &&  (attribute.representedElementKind != UICollectionView.elementKindSectionFooter)
        }

        for cell in cells {
            let paddingToDisapear = topHeader.frame.size.height + secondHeader.frame.size.height

            let hiddenFrameHeight = offset.y + paddingToDisapear - cell.frame.origin.y
            if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
                if let customCell = collectionView?.cellForItem(at: cell.indexPath) as? WeatherCollectionViewCell {
                    customCell.maskCell(fromTop: hiddenFrameHeight)
                }
            }
        }
        
        return attributes
    }
}
