//
//  TKLoadingView.m
//  Created by Devin Ross on 7/2/09.
//
/*
 
 tapku.com || http://github.com/devinross/tapkulibrary
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */
#import "TKLoadingView.h"
#import "UIView+TKCategory.h"

#define WIDTH_MARGIN 20
#define HEIGHT_MARGIN 20
#define VIEW_WIDTH 138
#define VIEW_HEIGHT 102

@interface TKLoadingView (PrivateMethods)
- (CGSize) calculateHeightOfTextFromWidth:(NSString*)text font: (UIFont*)withFont width:(float)width linebreak:(NSLineBreakMode)lineBreakMode;
@end


@implementation TKLoadingView
@synthesize radius;

- (void)showLoadingView {
	[self hideLoadingView];
	[self startAnimating];
	self.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hideLoadingView {
	if (self) {
		[self stopAnimating];
		[self removeFromSuperview];
	}
}

- (id) initWithTitle:(NSString*)ttl message:(NSString*)msg{
	if(!(self = [super initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)])) return nil;
		
    _title = [ttl copy];
    _message = [msg copy];
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:_activity];
    _hidden = YES;
    self.backgroundColor = [UIColor clearColor];
	
	return self;
}
- (id) initWithTitle:(NSString*)ttl{
    return [self initWithTitle:ttl message:nil];
}

- (void) drawRect:(CGRect)rect {
	
	if(_hidden) return;
	int width, rWidth, rHeight, x;
	
	UIFont *titleFont = [UIFont boldSystemFontOfSize:16];
	UIFont *messageFont = [UIFont systemFontOfSize:12];
	
	CGSize s1 = [self calculateHeightOfTextFromWidth:_title font:titleFont width:(VIEW_WIDTH - 2*WIDTH_MARGIN) linebreak:NSLineBreakByTruncatingTail];
	CGSize s2 = [self calculateHeightOfTextFromWidth:_message font:messageFont width:(VIEW_WIDTH - 2*WIDTH_MARGIN) linebreak:NSLineBreakByWordWrapping];
	
	if([_title length] < 1) s1.height = 0;
	if([_message length] < 1) s2.height = 0;
	
	
	rHeight = (s1.height + s2.height + (HEIGHT_MARGIN*2) + 10 + _activity.frame.size.height);
	rWidth = width = (s2.width > s1.width) ? (int) s2.width : (int) s1.width;
    if (rWidth < 90) {
        rWidth = width = 90;
    }
	rWidth += WIDTH_MARGIN * 2;
	x = (VIEW_WIDTH - rWidth) / 2;    
    
	_activity.center = CGPointMake(VIEW_WIDTH/2,HEIGHT_MARGIN/2 + _activity.frame.size.height/2);
	
	// DRAW ROUNDED RECTANGLE
	[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9] set];
    
	CGRect r = CGRectMake(x, 0, rWidth,rHeight);
    r.size.height = rHeight + 10;
	[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75] set];
	[UIView drawRoundRectangleInRect:r withRadius:10.0];
	
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"aboutLogo"]] autorelease];
    [self addSubview:imageView];

#ifdef __NUOMI_COM_HOTEL__
    imageView.frame = CGRectMake((VIEW_WIDTH/2 - 22), rHeight-26, 44, 25);
#else
    imageView.frame = CGRectMake((VIEW_WIDTH/2 - 22), rHeight-26, 44, 25);
#endif
    
    
	// DRAW FIRST TEXT
	[[UIColor whiteColor] set];
	r = CGRectMake(x+WIDTH_MARGIN, _activity.frame.size.height + HEIGHT_MARGIN - 4, width, s1.height);
	CGSize s = [_title drawInRect:r withFont:titleFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
	
	// DRAW SECOND TEXT
	r.origin.y += s.height;
	r.size.height = s2.height;
	[_message drawInRect:r withFont:messageFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
	
//	r = CGRectMake(_activity.frame.origin.x + 30, _activity.frame.origin.y, 100, s3.height);
//    [loadingStr drawInRect:r withFont:titleFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	
}


- (void) setTitle:(NSString*)str{
	[_title release];
	_title = [str copy];
	//[self updateHeight];
	[self setNeedsDisplay];
}
- (NSString*) title{
	return _title;
}

- (void) setMessage:(NSString*)str{
	[_message release];
	_message = [str copy];
	[self setNeedsDisplay];
}
- (NSString*) message{
	return _message;
}

- (void) setRadius:(float)f{
	if(f==radius) return;
	
	radius = f;
	[self setNeedsDisplay];
	
}

- (void) startAnimating{
	if(!_hidden) return;
	_hidden = NO;
	[self setNeedsDisplay];
	[_activity startAnimating];
	
}
- (void) stopAnimating{
	if(_hidden) return;
	_hidden = YES;
	[self setNeedsDisplay];
	[_activity stopAnimating];
	
}


- (CGSize) calculateHeightOfTextFromWidth:(NSString*)text font: (UIFont*)withFont width:(float)width linebreak:(NSLineBreakMode)lineBreakMode{
	return [text sizeWithFont:withFont 
			constrainedToSize:CGSizeMake(width, FLT_MAX) 
				lineBreakMode:lineBreakMode];
}



- (CGSize) heightWithString:(NSString*)str font:(UIFont*)withFont width:(float)width linebreak:(NSLineBreakMode)lineBreakMode{
	
	
	CGSize suggestedSize = [str sizeWithFont:withFont constrainedToSize:CGSizeMake(width, FLT_MAX) lineBreakMode:lineBreakMode];
	
	return suggestedSize;
}


- (void) adjustHeight{
	
	CGSize s1 = [self heightWithString:_title font:[UIFont boldSystemFontOfSize:16.0] 
								 width:200.0 
							 linebreak:NSLineBreakByTruncatingTail];
	
	CGSize s2 = [self heightWithString:_message font:[UIFont systemFontOfSize:12.0] 
								   width:200.0 
							   linebreak:NSLineBreakByWordWrapping];

	CGRect r = self.frame;
	r.size.height = s1.height + s2.height + 20;
	self.frame = r;
}





- (void) dealloc{
	[_activity release];
	[_title release];
	[_message release];
	[super dealloc];
}

@end