//
//  HZClollectionFlowLayout.swift
//  HZFlowCollectionlayout
//
//  Created by Yrl on 16/6/24.
//  Copyright © 2016年 Yrl. All rights reserved.
//

import UIKit

@objc protocol HZClollectionFlowLayoutDelegate: NSObjectProtocol {
    // 用来设置每一个cell的高度或宽度
   optional func heightForItemAtIndexPath(indexPath: NSIndexPath) -> CGFloat
    // 用来设置每一个cell的高度或宽度
   optional func widthForItemAtIndexPath(indexPath: NSIndexPath) -> CGFloat
}

class HZClollectionFlowLayout: UICollectionViewLayout {
    
    //布局集合
    private var  layoutAttributesArr: [UICollectionViewLayoutAttributes] = []
    //屏幕宽度
    private var oldScreenWidth: CGFloat = 0.0
    
    weak var flowLayoutdelegate: HZClollectionFlowLayoutDelegate?
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
        
        
        
        return layoutAttributesArr
    }
    
    func verticalToScoll(columns: Int) -> [UICollectionViewLayoutAttributes]?
    {
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var cellWidth: CGFloat = 0.0
        var cellHeight: CGFloat = 0.0
        var currentItemIndex = 0
        
        let totalNum = collectionView!.numberOfItemsInSection(0)
        if columns > 0
        { //向下瀑布流 width固定
            cellWidth = (collectionView!.frame.size.width - itemSpace*(CGFloat(columnsNum) + 1) )/CGFloat(columnsNum)
        }
        guard let delegate: HZClollectionFlowLayoutDelegate = flowLayoutdelegate else
        {
            assert(false,"请实现HZClollectionFlowLayoutDelegate")
            return nil
        }
        
        for index in 0..<totalNum
        {
            x = CGFloat(currentItemIndex) * cellWidth + (CGFloat(currentItemIndex)+1)*itemSpace
            y = endPosition[currentItemIndex] + itemSpace
            if let  height: CGFloat = delegate.heightForItemAtIndexPath!(NSIndexPath(forRow:index ,inSection:0)){
                cellHeight = height
            }
            if currentItemIndex < columns
            {
                currentItemIndex += 1
            }
            if let layoutAttributes: UICollectionViewLayoutAttributes =  initialLayoutAttributesForAppearingItemAtIndexPath(NSIndexPath(forRow:index ,inSection:0)){
                layoutAttributes.frame = CGRect(x: x,y: y,width: cellWidth,height: cellHeight)
                layoutAttributesArr.append(layoutAttributes)
            }
        }
        
        return layoutAttributesArr
    }
}
