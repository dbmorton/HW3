

#import "Utility.h"

@implementation Utility

// Gives you a random color
+(UIColor *)randomColor{
    
    float red = [self randomNumberBetweenZeroAnd:100] * 0.01;
    float green = [self randomNumberBetweenZeroAnd:100] * 0.01;
    float blue = [self randomNumberBetweenZeroAnd:100] * 0.01;
    float alpha = [self randomNumberBetweenZeroAnd:100] * 0.01;
    
    UIColor * tempColor =  [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    return tempColor;
}

// Gives you a number from 0 to maxnumber and returns an int
+(int)randomNumberBetweenZeroAnd:(int)maxNumber{
    int randomNum = arc4random() % maxNumber;
    return randomNum;
}

// Makes a label with your title
+(UILabel * )makeLabel:(NSString *)title :(int)size{
    
    UILabel * temp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
    temp.text = title;
    temp.font =  [UIFont fontWithName:@"HoeflerText-Black" size:size];
    temp.textColor = [UIColor blueColor];
    
    return temp;
}

// Makes a label with your title
+(UILabel * )makeSimpleLabel:(NSString *)text rect:(CGRect)rect FontName:(NSString*)fontName Size:(float)size{
    UILabel * temp = [[UILabel alloc]initWithFrame:rect];
    temp.text = text;
    temp.font =  [UIFont fontWithName:fontName size:size];
    temp.textColor = [UIColor blackColor];
    return temp;
}


// C function
double randomFloat()
{
    return (double)rand() / (double)RAND_MAX ;
}

//This function now can make multiple lines
+(UILabel *)makeUILabel:(NSString *)text withFontName:(NSString *)fontName fontSize:(int)size y:(float)y bgColor:(UIColor *)bgColor textColor:(UIColor *)tColor screenWidth:(float)sSize{
    
    UIFont *theFont=[UIFont fontWithName:fontName size:size];
    NSString *string=text;
    CGSize stringSize = [string sizeWithFont: theFont];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(sSize/2-stringSize.width/2, y,sSize,stringSize.height)];
    titleLabel.backgroundColor=bgColor;
    titleLabel.textColor=tColor;
    titleLabel.font = theFont;
    titleLabel.text=text;

    //Test if string can fit on one line
    if(stringSize.width>sSize){
        //NSLog(@"Creating Label with more than one line");
        titleLabel.numberOfLines=0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        titleLabel.textAlignment=UITextAlignmentCenter;
    }
    
    [titleLabel sizeToFit];
    
    CGRect rect= titleLabel.frame;
    titleLabel.frame=CGRectMake(sSize/2-rect.size.width/2, rect.origin.y, rect.size.width,rect.size.height);
    
    return titleLabel;
}


@end
