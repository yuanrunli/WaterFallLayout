//
//  HZClollectionFlowLayout.swift
//  HZFlowCollectionlayout
//
//  Created by Yrl on 16/6/24.
//  Copyright © 2016年 Yrl. All rights reserved.
//

import UIKit

protocol HZClollectionFlowLayoutDelegate: NSObjectProtocol {
    // 用来设置每一个cell的高度或宽度
    func heightOrWidthForItemAtIndexPath(indexPath: NSIndexPath) -> CGFloat
}

class HZClollectionFlowLayout: UICollectionViewLayout {
    
    //布局集合
    private var  layoutAttributes: [UICollectionViewLayoutAttributes] = []
    //屏幕宽度
    private var oldScreenWidth: CGFloat = 0.0
    // cell之间的间隙 默认为5.0
    var itemSpace: CGFloat = 5.0
    //列 cell的width固定，纵向滑动的瀑布流
    var columnsNum = 0 {
        willSet{
            for _ in 0..<columnsNum {
                endPosition.append(0)
            }
        }
        didSet {
            guard linesNum == 0 else{
                assert(false,"行数和列数只能固定一个")
                columnsNum = 0
            }
        }
    }
    //行 cell的height固定，横向滑动的瀑布流
    var linesNum = 0 {
        willSet{
            for _ in 0..<linesNum {
                endPosition.append(0)
            }
        }
        didSet {
            guard columnsNum != 0 else{
                assert(false,"行数和列数只能固定一个")
                linesNum = 0
            }
        }
    }
    
    //动态改变的最后位置
    private var  endPosition: [CGFloat] = []
    
    
    //MARK:  override
    override func prepareLayout() {
        super.prepareLayout()
        layoutAttributes = computeLayoutAttributes()
        oldScreenWidth = UIScreen.mainScreen().bounds.size.width
    }
    
    // Apple建议要重写这个方法, 因为某些情况下(delete insert...)系统可能需要调用这个方法来布局
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath.row]
    }
    
    // 必须重写这个方法来返回计算好的LayoutAttributes
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return layoutAttributes
    }
    
    
    // 当collectionView的bounds(滚动, 或者frame变化)发生改变的时候就会调用这个方法 ->true 调用prepareLayout()重新获得布局
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        // 旋转屏幕后刷新视图
        return newBounds.width != oldScreenWidth
    }
    
    override func collectionViewContentSize() -> CGSize {
        let max = endPosition.maxElement()!
        if linesNum==0 {
            return CGSize(width: 0.0,height: max)
        }
        return CGSize(width:max,height: 0)
    }
    
    //MARK: 计算
    // 计算所有的UICollectionViewLayoutAttributes
    func computeLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var width: CGFloat = 0.0
        var height: CGFloat = 0.0
        var currentItemIndex = 0
        
        
        let totalNum = collectionView?.numberOfItemsInSection(0)
        
    }
}
