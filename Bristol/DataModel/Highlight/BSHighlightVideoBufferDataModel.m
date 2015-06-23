//
//  BSHighlightVideoBufferDataModel.m
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "BSHighlightVideoBufferDataModel.h"

@implementation BSHighlightVideoBufferDataModel

+ (RKMapping *)responseMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{
                                                  @"id" : @"identifier",
                                                  @"client_id" : @"client_id",
                                                  @"user_id" : @"user_id",
                                                  @"video_path" : @"video_path",
                                                  @"cover_path" : @"cover_path",
                                                  @"thumbnail_path" : @"thumbnail_path",
                                                  @"video_file_name" : @"video_file_name",
                                                  @"video_content_type" : @"video_content_type",
                                                  @"cover_file_name" : @"cover_file_name",
                                                  @"cover_content_type" : @"cover_content_type",
                                                  @"thumbnail_file_name" : @"thumbnail_file_name",
                                                  @"thumbnail_content_type" : @"thumbnail_content_type",
                                                  @"created_at" : @"created_at",
                                                  @"updated_at" : @"updated_at",
                                                  }];
    
    return mapping;
}

@end
