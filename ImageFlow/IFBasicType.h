//
//  IFBasicType.h
//  ImageFlow
//
//  Created by Michel Schinz on 04.01.07.
//  Copyright 2007 Michel Schinz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "IFType.h"
#import "IFTypeTags.h"

@interface IFBasicType : IFType {
  IFParameterlessTypeTag tag;
}

+ (IFBasicType*)colorRGBAType;
+ (IFBasicType*)rectType;
+ (IFBasicType*)sizeType;
+ (IFBasicType*)pointType;
+ (IFBasicType*)stringType;
+ (IFBasicType*)floatType;
+ (IFBasicType*)intType;
+ (IFBasicType*)boolType;
+ (IFBasicType*)actionType;
+ (IFBasicType*)errorType;

+ (IFBasicType*)basicTypeWithTag:(int)theTag;

- (int)tag;

@end