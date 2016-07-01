//
//  ViewController.swift
//  HZFlowCollectionlayout
//
//  Created by Yrl on 16/6/24.
//  Copyright © 2016年 Yrl. All rights reserved.
//

import UIKit

let minHeight :UInt32 = 150
let maxHeight :UInt32 = 40

class ViewController: UICollectionViewController{
    var cellCount: Int = 8{
        didSet{
            let difference = cellCount-oldValue
            
            if  difference>0 {
                for _ in 0..<(cellCount - oldValue) {
                    cellHeight.append(CGFloat(arc4random() % maxHeight + minHeight))
                }
            }else{
                for _ in 0..<(oldValue - cellCount) {
                    cellHeight.removeLast()
                }
            }
            
        }
    }
    
    
    private lazy var cellHeight: [CGFloat] = {
        var arr:[CGFloat] = []
        for _ in 0..<self.cellCount {
            arr.append(CGFloat(arc4random() % maxHeight + minHeight))
        }
        return arr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.redColor()
        print(cellHeight)
        // 瀑布流
        setWaterFallLayout()
        
        self.collectionView?.addFooterRefresh(closure: { 
            dispatch_after(afterTime(3), dispatch_get_global_queue(0, 0), {
                self.collectionView?.stopPullRefresh()
                self.cellCount+=1
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView?.reloadData()
                })
            })
        })
        self.collectionView?.addPullRefresh({ 
            dispatch_after(afterTime(3), dispatch_get_global_queue(0, 0), {
                self.collectionView?.stopPullRefresh()
                let indexPath = NSIndexPath.init(forRow: self.cellCount, inSection: 0)
                self.cellCount+=1
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView?.performBatchUpdates({
                        self.collectionView?.insertItemsAtIndexPaths([indexPath])
                        }, completion: nil)
                })
            })
        })
    
    }

    private func setWaterFallLayout(){
        let collectionViewLayout = HZWaterFallCollectionLayer()
        collectionViewLayout.delegate = self
        collectionViewLayout.columnsNum = 4
        collectionView?.collectionViewLayout = collectionViewLayout
    }
    
}

extension ViewController: HZWaterFallCollectionLayerDelegate
{
    func heightForItemAtIndexPath(indexPath: NSIndexPath) -> CGFloat {
        return cellHeight[indexPath.row]
    }
}

extension ViewController {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellID", forIndexPath: indexPath)
        return cell
    }
    
//    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        if indexPath.row % 2 == 0 {//偶数
//            cellCount -= 1
//            cellHeight.removeAtIndex(indexPath.row)
//            collectionView.performBatchUpdates({
//                collectionView.deleteItemsAtIndexPaths([indexPath])
//                }, completion: nil)
//        } else {
//            cellCount += 1
//            cellHeight.append(CGFloat(arc4random() % 150 + 40))
//            
//            collectionView.performBatchUpdates({
//                collectionView.insertItemsAtIndexPaths([indexPath])
//                }, completion: nil)
//        }
//    }
}

