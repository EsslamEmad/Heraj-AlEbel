//
//  SeparatorCollectionViewFlowLayout.swift
//  3alsari3
//
//  Created by Mohamad Tarek on 16/6/19.
//  Copyright © 2019 Al-Youm-Host. All rights reserved.
//

import UIKit

// More info: https://www.raizlabs.com/dev/2014/02/animating-items-in-a-uicollectionview/
class SeparatorCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var indexPathsToInsert: [IndexPath] = []
    private var indexPathsToDelete: [IndexPath] = []
    
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        for item in updateItems {
            switch item.updateAction {
            case .delete:
                if let indexPath = item.indexPathBeforeUpdate {
                    indexPathsToDelete.append(indexPath)
                }
                
            case .insert:
                if let indexPath = item.indexPathAfterUpdate {
                    indexPathsToInsert.append(indexPath)
                }
                
            default:
                break
            }
        }
    }
    
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        indexPathsToDelete.removeAll()
        indexPathsToInsert.removeAll()
    }
    
    
    override func indexPathsToDeleteForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        return indexPathsToDelete
    }
    
    
    override func indexPathsToInsertForDecorationView(ofKind elementKind: String) -> [IndexPath] {
        return indexPathsToInsert
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributesArray = super.layoutAttributesForElements(in: rect) else { return nil }
        
        var decorationAttributes: [UICollectionViewLayoutAttributes] = []
        for layoutAttributes in layoutAttributesArray {
            
            let indexPath = layoutAttributes.indexPath
            if let separatorAttributes = layoutAttributesForDecorationView(ofKind: CollectionSeparatorView.className, at: indexPath) {
                if rect.intersects(separatorAttributes.frame) {
                    decorationAttributes.append(separatorAttributes)
                }
            }
        }
        
        let allAttributes = layoutAttributesArray + decorationAttributes
        return allAttributes
    }
    
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let cellAttributes = layoutAttributesForItem(at: indexPath) else {
            return createAttributesForMyDecoration(at: indexPath)
        }
        return layoutAttributesForMyDecoratinoView(at: indexPath, for: cellAttributes.frame, state: .normal)
    }
    
    
    override func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let cellAttributes = initialLayoutAttributesForAppearingItem(at: indexPath) else {
            return createAttributesForMyDecoration(at: indexPath)
        }
        return layoutAttributesForMyDecoratinoView(at: indexPath, for: cellAttributes.frame, state: .initial)
    }
    
    
    override func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let cellAttributes = finalLayoutAttributesForDisappearingItem(at: indexPath) else {
            return createAttributesForMyDecoration(at: indexPath)
        }
        return layoutAttributesForMyDecoratinoView(at: indexPath, for: cellAttributes.frame, state: .final)
    }
    
    
    // MARK: - privates
    
    private enum State {
        case initial
        case normal
        case final
    }
    
    
    private func setup() {
        register(CollectionSeparatorView.self, forDecorationViewOfKind: CollectionSeparatorView.className)
    }
    
    
    private func createAttributesForMyDecoration(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        return UICollectionViewLayoutAttributes(forDecorationViewOfKind: CollectionSeparatorView.className, with: indexPath)
    }
    
    
    private func layoutAttributesForMyDecoratinoView(at indexPath: IndexPath, for cellFrame: CGRect, state: State) -> UICollectionViewLayoutAttributes? {
        
        guard let rect = collectionView?.bounds else {
            return nil
        }
        
        let separatorAttributes = createAttributesForMyDecoration(at: indexPath)
        separatorAttributes.alpha = 1.0
        separatorAttributes.isHidden = false
        
        
        // vertical line
        
        separatorAttributes.frame = CGRect(x: cellFrame.maxX, y: cellFrame.origin.y + 12, width: minimumInteritemSpacing, height: cellFrame.height - 24)
       
        separatorAttributes.zIndex = 1000
        
        // Sync the decorator animation with the cell animation in order to avoid blinkining
        switch state {
        case .normal:
            separatorAttributes.alpha = 1
        default:
            separatorAttributes.alpha = 0.1
        }
        
        return separatorAttributes
    }
}
