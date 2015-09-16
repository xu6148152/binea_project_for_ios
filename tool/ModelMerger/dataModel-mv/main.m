//
//  main.m
//  dataModel-mv
//
//  Created by Xiao Zhang on 8/20/15.
//  Copyright (c) 2015 Xiao Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModelParser.h"

BOOL containsClass(NSArray *array, NSString *filename);

NSString *modelPath;
NSString *fromDirectory;
NSString *toDirectory;
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if(argc > 1)
        {
            for(int i = 1; i < argc; ++i)
            {
                if(strcmp(argv[i], "-m") == 0)
                {
                    if(++i < argc)
                    {
                        modelPath = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
                    }
                }
                else if(strcmp(argv[i], "-from") == 0)
                {
                    if(++i < argc)
                    {
                        fromDirectory = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
                    }
                }
                else if(strcmp(argv[i], "-to") == 0)
                {
                    if(++i < argc)
                    {
                        toDirectory = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
                    }
                }
            }
            
            if(modelPath && fromDirectory && toDirectory)
            {
                NSString *m = [[NSMutableString alloc] initWithContentsOfFile:[DataModelParser getFileName:modelPath] encoding:NSUTF8StringEncoding error:nil];
                NSArray *array = [DataModelParser getAllEntitiesClassNames:m];
                
                NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:fromDirectory];
                if(enumerator)
                {
                    NSString *obj = nil;
                    while(obj = [enumerator nextObject])
                    {
                        
                        if([obj hasSuffix:@".h"] || [obj hasSuffix:@".m"])
                        {
                            if(!containsClass(array, obj))
                            {
                                NSString *fromPath = [NSString stringWithFormat:[fromDirectory hasSuffix:@"/"]?@"%@%@":@"%@/%@", fromDirectory, obj];
                                NSString *toPath = [NSString stringWithFormat:[toDirectory hasSuffix:@"/"]?@"%@%@":@"%@/%@", toDirectory, obj];
                                if([obj hasPrefix:@"_"])
                                {
                                    [[NSFileManager defaultManager] removeItemAtPath:toPath error:nil];
                                }
                                [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:nil];
                                if([[NSFileManager defaultManager] fileExistsAtPath:fromPath])
                                {
                                    [[NSFileManager defaultManager] removeItemAtPath:fromPath error:nil];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return 0;
}

BOOL containsClass(NSArray *array, NSString *filename)
{
    for(NSString *c in array)
    {
        if([[NSString stringWithFormat:@"%@.h", c] isEqualToString:filename] ||
           [[NSString stringWithFormat:@"_%@.h", c] isEqualToString:filename] ||
           [[NSString stringWithFormat:@"%@.m", c] isEqualToString:filename] ||
           [[NSString stringWithFormat:@"_%@.m", c] isEqualToString:filename])
        {
            return YES;
        }
    }
    return NO;
}