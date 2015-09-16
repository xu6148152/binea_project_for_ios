//
//  main.m
//  dataModel
//
//  Created by Xiao Zhang on 8/3/15.
//  Copyright (c) 2015 Xiao Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "DataModelParser.h"

NSString *model0 = nil;
NSString *model1 = nil;
NSString *output = nil;
NSMutableArray *tables = nil;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if(argc > 1)
        {
            tables = [[NSMutableArray alloc] init];
            for(int i = 1; i < argc; ++i)
            {
                if(strcmp(argv[i], "-m0") == 0)
                {
                    if(++i < argc)
                    {
                        NSString *path = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
                        if([path hasSuffix:MODELD])
                        {
                            model0 = [[NSMutableString alloc] initWithContentsOfFile:[DataModelParser getFileName:[NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding]] encoding:NSUTF8StringEncoding error:nil];
                        }
                        else
                        {
                            NSLog(@"model 0: Invalid file name.");
                        }
                    }
                }
                else if(strcmp(argv[i], "-m1") == 0)
                {
                    if(++i < argc)
                    {
                        NSString *path = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
                        if([path hasSuffix:MODELD])
                        {
                            model1 = [[NSMutableString alloc] initWithContentsOfFile:[DataModelParser getFileName:[NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding]] encoding:NSUTF8StringEncoding error:nil];
                        }
                        else
                        {
                            NSLog(@"model 1: Invalid file name.");
                        }
                    }
                }
                else if(strcmp(argv[i], "-o") == 0)
                {
                    if(++i < argc)
                    {
                        NSString *path = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
                        if([path hasSuffix:MODELD])
                        {
                            output = [DataModelParser generateFileName:path];
                        }
                        else
                        {
                            NSLog(@"output: Invalid file name.");
                        }
                    }
                }
                else if(strcmp(argv[i], "-t") == 0)
                {
                    while(++i < argc)
                    {
                        if(argv[i][0] != '-')
                        {
                            [tables addObject:[NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding]];
                        }
                        else
                        {
                            --i;
                            break;
                        }
                    }
                }
            }
            
            if(model0 != nil && model1 != nil && output != nil)
            {
                NSMutableString *resString;
                if(tables.count)
                {
                    NSString *entity;
                    for(NSString *table in tables)
                    {
                        entity = [DataModelParser matchEntityString:table src:model1];
                        if(entity)
                        {
                            model0 = [DataModelParser replaceString:model0 m1:entity table:table];
                        }
                    }
                    resString = [NSMutableString stringWithString:model0];
                }
                else
                {
                    NSString *content = [DataModelParser matchAllEntitiesString:model1];
                    resString = [NSMutableString stringWithString:model0];
                    NSString *modelHeader = [DataModelParser matchModelHeaderString:model0];
                    NSRange range = [resString rangeOfString:modelHeader];
                    NSUInteger position = range.location + range.length;
                    [resString insertString:[NSString stringWithFormat:@"\n\t%@", content] atIndex:position];
                    [resString setString:[DataModelParser entityInherit:resString]];
                }
                
                if(resString)
                {
                    if (![[NSFileManager defaultManager] fileExistsAtPath:output])
                    {
                        NSError *error;
                        NSString *path = [output stringByDeletingLastPathComponent];
                        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
                        if(error)
                        {
                            NSLog(@"%@, %@", [error localizedDescription], [error userInfo]);
                        }
                    }
                    
                    NSError *error;
                    BOOL result = [resString writeToFile:output atomically:YES encoding:NSUTF8StringEncoding error:&error];
                    if(result)
                    {
                        NSLog(@"finished");
                    }
                    else
                    {
                        NSLog(@"%@, %@", [error localizedDescription], [error userInfo]);
                    }
                }
            }
        }
    }
    return 0;
}

