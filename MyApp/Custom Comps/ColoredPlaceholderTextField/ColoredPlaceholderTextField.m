//
//  ColoredPlaceholderTextField.m
//  esPronto
//
//  Created by Faustino L on 7/11/14.

//

#import "ColoredPlaceholderTextField.h"

@implementation ColoredPlaceholderTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)awakeFromNib
{
    if ([self.attributedPlaceholder length]) {
        // Extract attributes
        NSDictionary *attributes = (NSDictionary *)[(NSAttributedString *)self.attributedPlaceholder attributesAtIndex:0 effectiveRange:NULL];
        NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] initWithDictionary:attributes];
        [newAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        
        // Set new text with extracted attributes
        [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:[self.attributedPlaceholder string] attributes:newAttributes]];
    }
}

@end
