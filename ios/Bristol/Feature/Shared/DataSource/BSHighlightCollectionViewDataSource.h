//
//  BSHighlightCollectionViewDataSource.h
//  Bristol
//
//  Created by Yangfan Huang on 2/8/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSBaseCollectionViewDataSource.h"

@interface BSHighlightCollectionViewDataSource : BSBaseCollectionViewDataSource <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
	NSMutableArray *_highlights;
}
@end
