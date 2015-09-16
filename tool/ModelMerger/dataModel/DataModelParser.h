//
//  DataModelParser.h
//  dataModel
//
//  Created by Xiao Zhang on 8/20/15.
//  Copyright (c) 2015 Xiao Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MODELD @"xcdatamodeld"
#define MODEL @"xcdatamodel"
#define CONTENTS @"contents"

#define EXPRESSION_ENTITY @"<entity name=\"%@\"[\\s\\S]*?<\\/entity>"
#define EXPRESSION_ALL_ENTITIES @"<entity[\\s\\S]*(?=\\n+\\s+<elements>)"
#define EXPRESSION_MODEL_HEADER @"<model[\\s\\S]*?\">"
#define EXPRESSION_ENTITY_NAME @"(?<=<entity name=\")([^\"]*)(?=\")"
#define EXPRESSION_ENTITY_CLASS_NAME @"(?<=representedClassName=\")([^\"]*)(?=\")"
#define STR_PARENT_ENTITY @" parentEntity=\"%@\""
#define STR_BASE @"Base"
#define STR_X_CURRENT_VERSION @".xccurrentversion"

@interface DataModelParser : NSObject

+ (NSString *)matchAllEntitiesString:(NSString *)src;
+ (NSString *)matchEntityString:(NSString *)table src:(NSString *)src;
+ (NSString *)matchModelHeaderString:(NSString *)src;
+ (NSString *)replaceString:(NSString *)m0 m1:(NSString *)m1 table:(NSString *)table;
+ (NSString *)getFileName:(NSString *)path;
+ (NSString *)generateFileName:(NSString *)path;
+ (NSString *)entityInherit:(NSString *)src;
+ (NSString *)getCurrentVersion:(NSString *)path;
+ (NSString *)getDirectory:(NSString *)path;
+ (NSArray *)getAllEntitiesNames:(NSString *)content;
+ (NSArray *)getAllEntitiesClassNames:(NSString *)content;

@end