//
//  HZWaterFallCollectionLayout.swift
//  HZFlowCollectionlayout
//
//  Created by Yrl on 16/6/25.
//  Copyright © 2016年 Yrl. All rights reserved.
//

import UIKit

protocol HZWaterFallCollectionLayerDelegate: NSObjectProtocol {
    // 用来设置cell的高度
     func heightForItemAtIndexPath(indexPath: NSIndexPath) -> CGFloat
}

class HZWaterFallCollectionLayer: HZClollectionLayout {
    
    // cell之间的间隙 默认为5.0
    var itemSpace: CGFloat = 5.0
    // 列数
    var columnsNum = 0
    weak var delegate: HZWaterFallCollectionLayerDelegate?
    //每列的最后y坐标
    private var  maxYOfColums: [CGFloat] = []
    
    //MARK: overrid
    //overrid UICollectionViewLayout
    override func collectionViewContentSize() -> CGSize {
        let max = maxYOfColums.maxElement()!
        return CGSize(width:0,height: max)
    }
    //overrid HZClollectionLayout
    override func computeLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        return verticalToScoll(columnsNum)
    }
    
    
    //垂直瀑布计算方式
    func verticalToScoll(columns: Int) -> [UICollectionViewLayoutAttributes]
    {
        maxYOfColums = []
        for _ in 0..<columns {
            maxYOfColums.append(0)
        }
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var cellHeight: CGFloat = 0.0
        var currentColumn = 0
        var indexPath: NSIndexPath
        var attributesArr: [UICollectionViewLayoutAttributes] = []
        
        let totalNum = collectionView!.numberOfItemsInSection(0)
        //向下瀑布流 width固定
        let cellWidth = (collectionView!.bounds.size.width - itemSpace*(CGFloat(columns) + 1) )/CGFloat(columns)
        
        guard let self_delegate: HZWaterFallCollectionLayerDelegate = delegate else
        {
            assert(false,"请实现HZWaterFallCollectionLayerDelegate")
            return attributesArr
        }
        
        for currentIndex in 0..<totalNum
        {
            indexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
            cellHeight = self_delegate.heightForItemAtIndexPath(indexPath)
            
            if currentIndex < columns {// 第一行直接添加到当前的列
                currentColumn = currentIndex
                
            } else {// 其他行添加到最短的那一列
                // 这里使用!会得到期望的值
                let minMaxY = maxYOfColums.minElement()!
                currentColumn = maxYOfColums.indexOf(minMaxY)!
            }
            
            x = itemSpace + CGFloat(currentColumn) * (cellWidth + itemSpace)
            // 每个cell的y
            y = maxYOfColums[currentColumn] + itemSpace
            // 记录每一列的最后一个cell的最大Y
            maxYOfColums[currentColumn] = y + cellHeight
            
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath:indexPath)
            layoutAttributes.frame = CGRect(x: x,y: y,width: cellWidth,height: cellHeight)
            attributesArr.append(layoutAttributes)
            
        }
        
        return attributesArr
    }

}