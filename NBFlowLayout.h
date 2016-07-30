//
//  NBFlowLayout.h
//  瀑布流
//
//  Created by 孙亚东 on 15/5/1.
//  Copyright © 2015年 Sunyadong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBWaterFlowModel.h"
@class NBFlowLayout;

@protocol flowlayoutDelegate <NSObject>

@required

- (CGFloat)flowLayoutWithFlow: (NBFlowLayout *)flow andCellW: (CGFloat) CellW andindexPath:(NSIndexPath *)indexpath;

@end


@interface NBFlowLayout : UICollectionViewFlowLayout


@property (nonatomic,weak)id <flowlayoutDelegate> delegate;


@property (nonatomic,assign) NSInteger colCount;


@end
