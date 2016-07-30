//
//  NBFlowLayout.m
//  瀑布流
//
//  Created by 孙亚东 on 15/5/1.
//  Copyright © 2015年 Sunyadong. All rights reserved.
//

#import "NBFlowLayout.h"

@interface NBFlowLayout ()

//创建一个数组存放attributes

@property (nonatomic,strong)NSMutableArray *layoutArr;

//创建一个数组计算每一列的高度

@property (nonatomic,strong)NSMutableArray * colHeightArr;



@end


@implementation NBFlowLayout


- (void)prepareLayout{

    [self.layoutArr removeLastObject];
    
    
    NSInteger num =  [self.collectionView numberOfItemsInSection:0];
    
    NSInteger newContent =  num - self.layoutArr.count;
    
    
    for (NSInteger i = 0; i< newContent; i++) {
        
        NSIndexPath *index = [NSIndexPath indexPathForItem:self.layoutArr.count inSection:0];
        
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:index];
        
        
        //创建attributes的frame,首先要确定列数
        
        // 获取列号
        NSInteger colNum = [self minColNnm];
        
        
        // 内容宽度 = collectionView的宽 - 组的左边边距 - 组的右边边距
        CGFloat contentW = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right;
        
        // 计算cell的宽
        // cell的宽 = (内容的宽  - (列数 - 1) * 列间距) / 列数
        CGFloat cellW = (contentW - (self.colCount - 1) * self.minimumInteritemSpacing) / self.colCount;
        
        
        CGFloat attriX = (self.minimumInteritemSpacing + cellW)*colNum + self.sectionInset.left;
        
        //        CGFloat attriH = [self cellWidth:cellW andWatorModel:CGSizeMake(wator.width, wator.height)];
        
        CGFloat attriH = [self.delegate flowLayoutWithFlow:self andCellW:cellW andindexPath:index];
        //        [self CellWidth:100 andWatorModel:wator];
        
        
        
        //                CGFloat attriH = 150;
        CGFloat attriY = [self.colHeightArr[colNum] floatValue] ;
        
        // 重新定义self.colHeightArr[i]的值
        
        self.colHeightArr[colNum] = @(attriY+attriH+self.minimumLineSpacing);
        
        
        
        attributes.frame = CGRectMake(attriX, attriY, cellW, attriH);
        
        //将attributes添加到数组中
        [self.layoutArr addObject:attributes];
      
    
    }
    
    // 添加footerView的attributes
    
    NSIndexPath *footIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    
    UICollectionViewLayoutAttributes *attributesfoot = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter withIndexPath:footIndex];
    
     NSInteger col = [self maxColNum];
    
    CGFloat Y =[self.colHeightArr[col] floatValue];
                
    attributesfoot.frame = CGRectMake(0, Y , [UIScreen mainScreen].bounds.size.width, 40);
    
    [self.layoutArr addObject:attributesfoot];
    
    NSLog(@"self.layoutArr = %@",@(self.layoutArr.count));

}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{


    return self.layoutArr;


}


//重写contentSize方法
- (CGSize)collectionViewContentSize{
    
    NSInteger col = [self maxColNum];

    CGSize collectionSize = CGSizeMake(0, [self.colHeightArr[col] floatValue]+40);
    
    return collectionSize;


}


- (CGFloat )cellWidth: (CGFloat)cellW andWatorModel: (CGSize) imageSize{
    
    
    return imageSize.height/imageSize.width*cellW;
    
}


-(NSInteger )maxColNum {

    NSInteger  maxCol = 0;
    
    CGFloat  maxHeight = 0;
    
    for (NSInteger i =0; i<self.colHeightArr.count; i++) {
        
        if ([self.colHeightArr[i] floatValue]>maxHeight) {
            maxHeight = [self.colHeightArr[i] floatValue];
            
            maxCol = i;
            
        }
        
        
    }


    return maxCol;

}

- (NSInteger) minColNnm{

    NSInteger minCol = 0;
    CGFloat minHeight = MAXFLOAT;
    
    for (NSInteger i = 0; i<self.colHeightArr.count; i++) {
        
        if ([self.colHeightArr[i] floatValue]< minHeight) {
            minHeight = [self.colHeightArr[i] floatValue];
            
            minCol = i;
        }
        
        
    }

    return minCol;

}


//懒加载初始化self.layArrM
- (NSMutableArray*)layoutArr{
    if (_layoutArr == nil) {
        _layoutArr = [NSMutableArray array];
    }


    return _layoutArr;

}



//通过一个数组存放每一列的高度

- (NSMutableArray*)colHeightArr{

    if (_colHeightArr == nil) {
        NSMutableArray * arrM = [NSMutableArray arrayWithCapacity:self.colCount];
        
        for (int i = 0; i<self.colCount; i++) {
            arrM[i] = @(self.sectionInset.top);

        }
        
        
        _colHeightArr = arrM;
    }


    return _colHeightArr;



}


@end
