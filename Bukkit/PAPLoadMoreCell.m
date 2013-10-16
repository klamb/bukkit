//
//  PAPLoadMoreCell.m
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/17/12.
//

#import "PAPLoadMoreCell.h"

@implementation PAPLoadMoreCell

@synthesize cellInsetWidth;
@synthesize mainView;
@synthesize separatorImageTop;
@synthesize separatorImageBottom;
@synthesize loadMoreImageView;
@synthesize hideSeparatorTop;
@synthesize hideSeparatorBottom;


#pragma mark - NSObject

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // Initialization code
        self.cellInsetWidth = 0.0f;
        hideSeparatorTop = NO;
        hideSeparatorBottom = NO;

        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor clearColor];
        
        mainView = [[UIView alloc] initWithFrame:self.contentView.frame];
        [mainView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundComments.png"]]];
        
        self.loadMoreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellLoadMore.png"]];
        [mainView addSubview:self.loadMoreImageView];
        
        self.separatorImageTop = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SeparatorComments.png"] resizableImageWithCapInsets:UIEdgeInsetsMake( 0.0f, 1.0f, 0.0f, 1.0f)]];
        [mainView addSubview:separatorImageTop];
        
        self.separatorImageBottom = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SeparatorComments.png"] resizableImageWithCapInsets:UIEdgeInsetsMake( 0.0f, 1.0f, 0.0f, 1.0f)]];
        [mainView addSubview:separatorImageBottom];

        [self.contentView addSubview:mainView];
    }
    
    return self;
}


#pragma mark - UIView

- (void)layoutSubviews {
    [mainView setFrame:CGRectMake( self.cellInsetWidth, self.contentView.frame.origin.y, self.contentView.frame.size.width-2*self.cellInsetWidth, self.contentView.frame.size.height)];
    
    // Layout load more text
    [self.loadMoreImageView setFrame:CGRectMake( -self.cellInsetWidth, -2.0f, 320.0f, 31.0f)];

    // Layout separator
    [self.separatorImageBottom setFrame:CGRectMake( 0.0f, self.frame.size.height - 2.0f, self.frame.size.width-self.cellInsetWidth * 2.0f, 2.0f)];
    [self.separatorImageBottom setHidden:hideSeparatorBottom];
    
    [self.separatorImageTop setFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width - self.cellInsetWidth * 2.0f, 2.0f)];
    [self.separatorImageTop setHidden:hideSeparatorTop];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.cellInsetWidth != 0.0f) {
        [self drawSideDropShadowForRect:mainView.frame inContext:UIGraphicsGetCurrentContext()];
    }
}

- (void)drawSideDropShadowForRect:(CGRect)rect inContext:(CGContextRef)context {
    // Push the context
    CGContextSaveGState(context);
    
    // Set the clipping path to remove the rect drawn by drawing the shadow
    CGRect boundingRect = CGContextGetClipBoundingBox(context);
    CGContextAddRect(context, boundingRect);
    CGContextAddRect(context, rect);
    CGContextEOClip(context);
    // Also clip the top and bottom
    CGContextClipToRect(context, CGRectMake(rect.origin.x - 10.0f, rect.origin.y, rect.size.width + 20.0f, rect.size.height));
    
    // Draw shadow
    [[UIColor blackColor] setFill];
    CGContextSetShadow(context, CGSizeMake(0.0f, 0.0f), 7.0f);
    CGContextFillRect(context, CGRectMake(rect.origin.x,
                                          rect.origin.y - 5.0f,
                                          rect.size.width,
                                          rect.size.height + 10.0f));
    // Save context
    CGContextRestoreGState(context);
}

#pragma mark - PAPLoadMoreCell

- (void)setCellInsetWidth:(CGFloat)insetWidth {
    cellInsetWidth = insetWidth;
    [mainView setFrame:CGRectMake( insetWidth, mainView.frame.origin.y, mainView.frame.size.width - 2.0f * insetWidth, mainView.frame.size.height)];
    [self setNeedsDisplay];
}

@end
