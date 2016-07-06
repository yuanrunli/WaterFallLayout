//
//  HZWaterFallHorizontalLayout.swift
//  HZFlowCollectionlayout
//
//  Created by Yrl on 16/6/25.
//  Copyright © 2016年 Yrl. All rights reserved.
//

import UIKit

protocol HZWaterFallHorizontalLayoutDelegate: NSObjectProtocol {
    // 用来设置cell的宽度
    func WidthForItemAtIndexPath(indexPath: NSIndexPath) -> CGFloat
}

class HZWaterFallHorizontalLayout: HZClollectionLayout {
    // cell之间的间隙 默认为5.0
    var itemSpace: CGFloat = 5.0
    // 数
    var linesNum = 0 {
        willSet{
            for _ in 0..<linesNum {
                maxXOfLines.append(0)
            }
        }
    }
    weak var delegate: HZWaterFallHorizontalLayoutDelegate?
    //每行的最后x坐标
    private var  maxXOfLines: [CGFloat] = []
    
    //MARK: overrid
    //overrid UICollectionViewLayout
    override func collectionViewContentSize() -> CGSize {
        let max = maxXOfLines.maxElement()!
        let width: CGFloat
        if max>UIScreen.mainScreen().bounds.size.width {
            width = max
        }else{
            width = UIScreen.mainScreen().bounds.size.width
        }

        return CGSize(width:width,height: 0)
    }
    //overrid HZClollectionLayout
    override func computeLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        return HorizontalToScoll(linesNum)
    }
    
    //垂直瀑布计算方式
    func HorizontalToScoll(lines: Int) -> [UICollectionViewLayoutAttributes]
    {
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var cellWidth: CGFloat = 0.0
        var currentLineIndex = 0
        var indexPath: NSIndexPath
        var attributesArr: [UICollectionViewLayoutAttributes] = []
        
        let totalNum = collectionView!.numberOfItemsInSection(0)
        //向下瀑布流 width固定
        let cellHeight = (collectionView!.bounds.size.height - itemSpace*(CGFloat(lines) + 1) )/CGFloat(lines)
        
        guard let self_delegate: HZWaterFallHorizontalLayoutDelegate = delegate else
        {
            assert(false,"请实现HZWaterFallHorizontalLayoutDelegate")
            return attributesArr
        }
        
        for currentIndex in 0..<totalNum
        {
            indexPath = NSIndexPath(forItem: currentIndex, inSection: 0)
            cellWidth = self_delegate.WidthForItemAtIndexPath(indexPath)
            
            if currentIndex < lines
            {
                currentLineIndex = currentIndex
            }else{
                let min = maxXOfLines.minElement()!
                currentLineIndex = maxXOfLines.indexOf(min)!
            }
    
            x = itemSpace + maxXOfLines[currentLineIndex]
            y = itemSpace + CGFloat(currentLineIndex)*(cellHeight + itemSpace)
            // 记录每一行的最后一个cell的最大X
            maxXOfLines[currentLineIndex] = x + cellWidth
            
            let layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath:indexPath)
            layoutAttributes.frame = CGRect(x: x,y: y,width: cellWidth,height: cellHeight)
            attributesArr.append(layoutAttributes)
            
        }
        
        return attributesArr
    }
}