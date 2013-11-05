#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(UIColor *)randomColor;
+(int)randomNumberBetweenZeroAnd:(int)maxNumber;
+(UILabel * )makeLabel:(NSString *)title :(int)size;

+(UILabel *)makeUILabel:(NSString *)text withFontName:(NSString *)name fontSize:(int)size y:(float)y bgColor:(UIColor *)bgColor textColor:(UIColor *)tColor screenWidth:(float)sSize;

+(UILabel * )makeSimpleLabel:(NSString *)text rect:(CGRect)rect FontName:(NSString*)fontName Size:(float)size;

double randomFloat();

@end
