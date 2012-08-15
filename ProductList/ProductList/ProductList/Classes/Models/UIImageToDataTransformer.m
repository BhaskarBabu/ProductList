//
//  UIImageToDataTransformer.m
//  ProductList
//
//  Created by Bhaskar N on 15/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImageToDataTransformer.h"

@interface UIImage (NSCoding)

- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

@end

@implementation UIImageToDataTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}

- (id)transformedValue:(id)value {
	return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value {
	return [[[UIImage alloc] initWithData:value] autorelease];
}

@end

@implementation UIImage (NSCoding)

- (id)initWithCoder:(NSCoder *)decoder
{
    NSData *pngData = [decoder decodeObjectForKey:@"PNGRepresentation"];
    [self autorelease];
    self = [[UIImage alloc] initWithData:pngData];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:UIImagePNGRepresentation(self) forKey:@"PNGRepresentation"];
}

@end