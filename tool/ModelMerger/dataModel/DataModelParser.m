//
//  DataModelParser.m
//  dataModel
//
//  Created by Xiao Zhang on 8/20/15.
//  Copyright (c) 2015 Xiao Zhang. All rights reserved.
//

#import "DataModelParser.h"

@implementation DataModelParser

+ (NSRegularExpression *)getRegularExpression:(NSString *)str
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:str options:NSRegularExpressionCaseInsensitive error:nil];
    return regex;
}

+ (NSString *)matchAllEntitiesString:(NSString *)src
{
    NSString *desc = nil;
    NSRegularExpression *regex = [self getRegularExpression:EXPRESSION_ALL_ENTITIES];
    
    NSArray *matches = [regex matchesInString:src options:0 range:NSMakeRange(0, [src length])] ;
    
    if(matches.count > 0)
    {
        NSTextCheckingResult *match = [matches objectAtIndex:0];
        desc = [src substringWithRange:[match rangeAtIndex:0]];
    }
    return desc;
}

+ (NSString *)matchEntityString:(NSString *)table src:(NSString *)src
{
    NSString *desc = nil;
    NSRegularExpression *regex = [self getRegularExpression:[[NSString alloc] initWithFormat:EXPRESSION_ENTITY, table]];
    
    NSArray *matches = [regex matchesInString:src options:0 range:NSMakeRange(0, [src length])] ;
    
    if(matches.count > 0)
    {
        NSTextCheckingResult *match = [matches objectAtIndex:0];
        desc = [src substringWithRange:[match rangeAtIndex:0]];
    }
    return desc;
}

+ (NSString *)matchModelHeaderString:(NSString *)src
{
    NSString *desc = nil;
    NSRegularExpression *regex = [self getRegularExpression:EXPRESSION_MODEL_HEADER];
    
    NSArray *matches = [regex matchesInString:src options:0 range:NSMakeRange(0, [src length])] ;
    
    if(matches.count > 0)
    {
        NSTextCheckingResult *match = [matches objectAtIndex:0];
        desc = [src substringWithRange:[match rangeAtIndex:0]];
    }
    return desc;
}

+ (NSString *)replaceString:(NSString *)m0 m1:(NSString *)m1 table:(NSString *)table
{
    NSString *desc = m0;
    NSRegularExpression *regex = [self getRegularExpression:[[NSString alloc] initWithFormat:EXPRESSION_ENTITY, table]];
    desc = [regex stringByReplacingMatchesInString:m0 options:0 range:NSMakeRange(0, m0.length) withTemplate:m1];
    return desc;
}



+ (NSString *)getFileName:(NSString *)path
{
    NSMutableString *filename = [NSMutableString stringWithString:path];
    NSString *version = [self getCurrentVersion:filename];
    if(version)
    {
        [filename appendFormat:@"/%@", version];
    }
    [self enumerateDirectory:filename];
    return filename;
}

+ (NSString *)generateFileName:(NSString *)path
{
    NSMutableString *filename = [NSMutableString stringWithString:path];
    NSString* name = [[filename lastPathComponent] stringByDeletingPathExtension];
    if(name)
    {
        [filename appendFormat:@"/%@.%@/%@", name, MODEL, CONTENTS];
    }
    return filename;
}

+ (NSString *)entityInherit:(NSString *)src
{
    NSMutableString * dest = [NSMutableString stringWithString:src];
    NSArray *entities = [self getAllEntitiesNames:src];
    
    for(NSString *p in entities)
    {
        if([p hasPrefix:STR_BASE])
        {
            NSString *childEntity = [p substringFromIndex:[p rangeOfString:STR_BASE].length];
            for(NSString *c in entities)
            {
                if([c isEqualToString:childEntity])
                {
                    NSRange range = [src rangeOfString:[NSString stringWithFormat:@"<entity name=\"%@\"", childEntity]];
                    NSInteger position = range.location + range.length;
                    
                    [dest insertString:[NSString stringWithFormat:STR_PARENT_ENTITY, p] atIndex:position];
                }
            }
        }
    }
    return dest;
}

+ (NSString *)getCurrentVersion:(NSString *)path
{
    NSString *version;
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    NSString *filename;
    NSDictionary *dict;
    while(filename = [enumerator nextObject])
    {
        if([filename isEqualToString:STR_X_CURRENT_VERSION])
        {
            dict = [[NSDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", path, filename]];
            if(dict)
            {
                version = dict[@"_XCCurrentVersionName"];
                break;
            }
        }
    }
    
    return version;
}

+ (void) enumerateDirectory:(NSMutableString *)path
{
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
    if(enumerator)
    {
        NSString *obj = nil;
        if(obj = [enumerator nextObject])
        {
            [path appendFormat:@"/%@", obj];
            [self enumerateDirectory:path];
        }
    }
}

+ (NSString *)getDirectory:(NSString *)path
{
    return [path stringByDeletingLastPathComponent];
}

+ (NSArray *)getAllEntitiesNames:(NSString *)content
{
    NSRegularExpression *regex = [self getRegularExpression:EXPRESSION_ENTITY_NAME];
    
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    NSMutableArray *entitiesNames = [[NSMutableArray alloc] init];
    for(NSTextCheckingResult *match in matches)
    {
        [entitiesNames addObject:[content substringWithRange:[match rangeAtIndex:0]]];
    }
    return entitiesNames;
}

+ (NSArray *)getAllEntitiesClassNames:(NSString *)content
{
    NSRegularExpression *regex = [self getRegularExpression:EXPRESSION_ENTITY_CLASS_NAME];
    
    NSArray *matches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
    NSMutableArray *entitiesClassNames = [[NSMutableArray alloc] init];
    for(NSTextCheckingResult *match in matches)
    {
        [entitiesClassNames addObject:[content substringWithRange:[match rangeAtIndex:0]]];
    }
    return entitiesClassNames;
}
@end
