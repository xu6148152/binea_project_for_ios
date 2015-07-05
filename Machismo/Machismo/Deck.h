//
//  Deck.h
//  Machismo
//
//  Created by Binea Xu on 7/5/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

-(Card*) drawRandomCard;

@end
