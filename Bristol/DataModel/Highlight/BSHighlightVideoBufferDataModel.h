//
//  BSHighlightVideoBufferDataModel.h
//  Bristol
//
//  Created by Guichao Huang (Gary) on 2/4/15.
//  Copyright (c) 2015 Zepp US Inc. All rights reserved.
//

#import "ZPBaseDataModel.h"

@interface BSHighlightVideoBufferDataModel : ZPBaseDataModel

@property(nonatomic, assign) DataModelIdType identifier;
@property(nonatomic, assign) DataModelIdType client_id;
@property(nonatomic, assign) DataModelIdType user_id;
@property(nonatomic, strong) NSString *video_path;
@property(nonatomic, strong) NSString *cover_path;
@property(nonatomic, strong) NSString *thumbnail_path;
@property(nonatomic, strong) NSString *video_file_name;
@property(nonatomic, strong) NSString *video_content_type;
@property(nonatomic, strong) NSString *cover_file_name;
@property(nonatomic, strong) NSString *cover_content_type;
@property(nonatomic, strong) NSString *thumbnail_file_name;
@property(nonatomic, strong) NSString *thumbnail_content_type;
@property(nonatomic, strong) NSDate *created_at;
@property(nonatomic, strong) NSDate *updated_at;

@end
