//
//  IFMaskToImageCIFilter.h
//  ImageFlow
//
//  Created by Michel Schinz on 16.10.06.
//  Copyright 2006 Michel Schinz. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IFMaskToImageCIFilter : CIFilter {
  CIImage* inputMask;
}

@end
