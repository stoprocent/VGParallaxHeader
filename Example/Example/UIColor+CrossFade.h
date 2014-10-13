/**
 * Copyright (c) 2012-2013 Charles Powell
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

//
//  UIColor+CrossFade.h
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIColor (CrossFade)

/**
 * Fades between firstColor and secondColor at the specified ratio:
 * 
 *    @ ratio 0.0 - fully firstColor
 *    @ ratio 0.5 - halfway between firstColor and secondColor
 *    @ ratio 1.0 - fully secondColor
 *
 */

+ (UIColor *)colorForFadeBetweenFirstColor:(UIColor *)firstColor 
                               secondColor:(UIColor *)secondColor 
                                   atRatio:(CGFloat)ratio;

/**
 * Same as above, but allows turning off the color space comparison
 * for a performance boost.
 */

+ (UIColor *)colorForFadeBetweenFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor atRatio:(CGFloat)ratio compareColorSpaces:(BOOL)compare;

/**
 * An array of [steps] colors starting with firstColor, continuing with linear interpolations 
 * between firstColor and lastColor and ending with lastColor.
 */
+ (NSArray *)colorsForFadeBetweenFirstColor:(UIColor *)firstColor
                                lastColor:(UIColor *)lastColor
                                    inSteps:(NSUInteger)steps;

/**
 * An array of [steps] colors starting with firstColor, continuing with interpolations, as specified
 * by the equation block, between firstColor and lastColor and ending with lastColor. The equation block
 * must take a float as an input, and return a float as an output. Output will be santizied to be between
 * a ratio of 0.0 and 1.0. Passing nil for the equation results in a linear relationship.
 */
+ (NSArray *)colorsForFadeBetweenFirstColor:(UIColor *)firstColor 
                                  lastColor:(UIColor *)lastColor 
                          withRatioEquation:(float (^)(float input))equation
                                    inSteps:(NSUInteger)steps;
    

/**
 * Convert UIColor to RGBA colorspace. Used for cross-colorspace interpolation.
 */
+ (UIColor *)colorConvertedToRGBA:(UIColor *)colorToConvert;


/**
 * Creates a CAKeyframeAnimation for the given key path, duration, and first/last colors that can be
 * applied to an appropriate CALayer property (i.e. backgroundColor). See the demo for example usage.
 */
+ (CAKeyframeAnimation *)keyframeAnimationForKeyPath:(NSString *)keyPath
                                            duration:(NSTimeInterval)duration
                                   betweenFirstColor:(UIColor *)firstColor
                                           lastColor:(UIColor *)lastColor;


/**
 * Same as above, but allows setting a ratio equation (for non-linear transitions between colors) and
 * the number of steps to calculate. Decreasing steps may improve performance as it decreases the number
 * of cross-fade calculations necessary.
 */
+ (CAKeyframeAnimation *)keyframeAnimationForKeyPath:(NSString *)keyPath
                                            duration:(NSTimeInterval)duration
                                   betweenFirstColor:(UIColor *)firstColor
                                           lastColor:(UIColor *)lastColor
                                   withRatioEquation:(float (^)(float))equation
                                             inSteps:(NSUInteger)steps;

@end
