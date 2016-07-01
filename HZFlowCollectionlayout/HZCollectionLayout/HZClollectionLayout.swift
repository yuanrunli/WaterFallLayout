//
//  HZClollectionLayout.swift
//  HZFlowCollectionlayout
//
//  Created by Yrl on 16/6/24.
//  Copyright © 2016年 Yrl. All rights reserved.
//

import UIKit

class HZClollectionLayout: UICollectionViewLayout {
    
    //布局集合
    private var  layoutAttributesArr: [UICollectionViewLayoutAttributes] = []
    //屏幕宽度
    private var oldScreenWidth: CGFloat = 0.0
    
    
    //MARK:  override
    override func prepareLayout() {
        super.prepareLayout()
        layoutAttributesArr = computeLayoutAttributes()
        oldScreenWidth = UIScreen.mainScreen().bounds.size.width
    }
    
    // Apple建议要重写这个方法, 因为某些情况下(delete insert...)系统可能需要调用这个方法来布局
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributesArr[indexPath.row]
    }
    
    // 必须重写这个方法来返回计算好的LayoutAttributes
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return layoutAttributesArr
    }
    
    
    // 当collectionView的bounds(滚动, 或者frame变化)发生改变的时候就会调用这个方法 ->true 调用prepareLayout()重新获得布局
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        // 旋转屏幕后刷新视图
        return newBounds.width != oldScreenWidth
    }
    
    
    
    //MARK: 计算
    // 计算所有的UICollectionViewLayoutAttributes
    func computeLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        
        return layoutAttributesArr
    }
    
    
}
