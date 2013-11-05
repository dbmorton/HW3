#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kYouTubeMostPop [NSURL URLWithString:@"http://gdata.youtube.com/feeds/api/standardfeeds/most_popular?v=2&alt=json"]

#import "ViewController.h"
#import "Utility.h"

#define SCREEN_WIDTH self.view.frame.size.width
#define SCREEN_HEIGHT self.view.frame.size.height

@interface ViewController ()
@end
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dispatch_async(kBgQueue, ^{
        NSData * data = [NSData dataWithContentsOfURL:kYouTubeMostPop];
        
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
}

-(void)populateView{
    //VARS
    float edgeOffset=20;
    float boxWidth=SCREEN_WIDTH-edgeOffset*2;
    float boxHeight=SCREEN_HEIGHT-edgeOffset*2;
    float scrollWidth=boxWidth*[_youTubeRecordArray count];
    /*
     //DEBUG INFO
     NSLog(@"SCREEN_WIDTH=%f",SCREEN_WIDTH);
     NSLog(@"SCREEN_HEIGHT=%f",SCREEN_HEIGHT);
     NSLog(@"edgeOffset=%f",edgeOffset);
     NSLog(@"boxWidth=%f",boxWidth);
     NSLog(@"boxHeight=%f",boxHeight);
     NSLog(@"scrollWidth=%f",scrollWidth);
     NSLog(@"records=%i",[_youTubeRecordArray count]);
     */
    
    //VARS
    float titlePerc=.075;
    float thumbPerc=.35;
    float authorPerc=.05;
    float viewCountPerc=.03;
    float descPerc=.40;
    float linkPerc=1.00-titlePerc-thumbPerc-authorPerc-viewCountPerc-descPerc;
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(edgeOffset,edgeOffset, boxWidth , boxHeight)];
    scroll.backgroundColor = [UIColor whiteColor];
    scroll.indicatorStyle = UIScrollViewIndicatorStyleBlack; //UIScrollViewIndicatorStyleWhite
	
    // Snaps to a page
    scroll.pagingEnabled = YES;
	
    for (int i = 0; i < [_youTubeRecordArray count] ;i++) {
        YouTubeRecord *record=[_youTubeRecordArray objectAtIndex:i];
        
        float boxX=i*boxWidth;
        //NSLog(@"Making box %f,%f,%f,%f",boxX,0.0,boxWidth,boxHeight);
        UIView * box = [[UIView alloc]initWithFrame:CGRectMake( boxX, 0 , boxWidth, boxHeight)];
        box.backgroundColor = [UIColor whiteColor];
        [scroll addSubview:box];
       
        //TITLE
        UILabel *thisLabel=[Utility makeUILabel:record.title withFontName:@"Times New Roman" fontSize:14.0 y:0.0 bgColor:[UIColor whiteColor] textColor:[UIColor blackColor] screenWidth:boxWidth];
        
        [box addSubview:thisLabel];
        
        //IMAGE VIEW
        UIImageView *imageView = [[UIImageView alloc]initWithImage:record.thumbnailImage];
        imageView.frame = CGRectMake(0, boxHeight*titlePerc, boxWidth,boxHeight*thumbPerc);
        //imageView.center = CGPointMake(10,10);
        imageView.backgroundColor = [UIColor clearColor];
        // setting content mode will keep the aspect ratio of you image
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [box addSubview:imageView];

        //Author
        float currentY=(boxHeight*(titlePerc+thumbPerc));
        UILabel *authorLabel=[Utility makeSimpleLabel:record.author rect:CGRectMake(0, currentY, boxWidth, boxHeight*authorPerc) FontName:@"Times New Roman" Size:14.0];
        //UILabel *authorLabel=[Utility makeUILabel:record.author withFontName:@"Times New Roman" fontSize:14.0 y:currentY bgColor:[UIColor whiteColor] textColor:[UIColor blackColor] screenWidth:boxWidth];
        [box addSubview:authorLabel];
        
        //VIEW COUNT
        currentY=currentY+authorPerc*boxHeight;
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *viewCountText=[NSString stringWithFormat:@"%@ %@",[numberFormatter stringFromNumber:[NSNumber numberWithInteger:record.viewCount ]],@" Views"];
        
        
        UILabel *viewCountLabel=[Utility makeSimpleLabel:viewCountText rect:CGRectMake(0, currentY, boxWidth, boxHeight*viewCountPerc) FontName:@"Times New Roman" Size:8.0];
       
        //[Utility makeUILabel:[NSString stringWithFormat:@"%i",record.viewCount] withFontName:@"Times New Roman" fontSize:10.0 y:currentY bgColor:[UIColor whiteColor] textColor:[UIColor blackColor] screenWidth:boxWidth];
        [box addSubview:viewCountLabel];
        
        //DESCRIPTION
        currentY=currentY+viewCountPerc*boxHeight;
        UITextView *descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(0, currentY, boxWidth, descPerc*boxHeight)];
        descriptionView.backgroundColor = [UIColor whiteColor];
        descriptionView.textColor = [UIColor blackColor];
        descriptionView.font = [UIFont fontWithName: @"Times New Roman" size: 10.0];
        descriptionView.editable = NO;
        descriptionView.selectable=NO;
        descriptionView.text =record.description;
        [box addSubview: descriptionView];
        
        currentY=currentY+descPerc*boxHeight;
        UIButton * linkButton = [UIButton buttonWithType:UIButtonTypeSystem];
        linkButton.frame = CGRectMake(0,currentY, boxWidth,boxHeight*linkPerc);
        //linkButton.center=CGPointMake(0,0);
        [linkButton setTitle:@"Watch Video" forState:UIControlStateNormal];
        
        [linkButton addTarget:record action: @selector(openLink) forControlEvents: UIControlEventTouchUpInside];
        [box addSubview:linkButton];
        
        
    }
    // Set size of scroll plane / content size
    scroll.contentSize = CGSizeMake(scrollWidth  , boxHeight);
    [self.view addSubview:scroll];
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    NSDictionary * feed = [json objectForKey:@"feed"];
    
    /*
     // FOR DEBUG - Print each item in NSDictionary feed
    for (NSString *s in feed) {NSLog(@"feed: %@", s );}
     */
    
    NSArray * entry = [feed objectForKey:@"entry"];
    
    /*
     //FOR DEBUG IF NECESSARY
     for (NSString *s in entry) {NSLog(@"entry: %@", s );}
     NSDictionary * node = [entry objectAtIndex:0];
     for (NSString *s in node) {NSLog(@"node: %@", s );}
     */
    
    //https://developers.google.com/youtube/2.0/reference#youtubeDataAPIFeedTypes
    
    _youTubeRecordArray=[[NSMutableArray alloc] init];
    
    for (NSDictionary *e in entry) {
        //A YouTubeRecord is created for each result
        YouTubeRecord *record=[[YouTubeRecord alloc] init];
        
        //GET TITLE
        NSDictionary * title = [e objectForKey:@"title"];
        record.title=[title objectForKey:@"$t"];
        
        //GET AUTHOR
        NSArray * author = [e objectForKey:@"author"];
        NSDictionary *firstObjectArray=[author objectAtIndex:0];
        NSDictionary *dict=[firstObjectArray objectForKey:@"name"];
        record.author=[dict objectForKey:@"$t"];
        
        //GET LINK
        //We need to iterate to make sure we get the where "rel"="alternate"
        NSArray * link = [e objectForKey:@"link"];
        for(int i=0;i<[link count];++i){
            NSDictionary *thisDicationary=[link objectAtIndex:i];
            NSString *thisRel=[thisDicationary objectForKey:@"rel"];
            if([thisRel isEqual: @"alternate"]){
                record.link=[thisDicationary objectForKey:@"href"];
            }
        }
        
        /* FOR DEBUG - IF NECESSARY
        for (NSString* key in firstObjectArray) {NSLog(@"this key=%@",key);}
        for (NSString *s in author) {NSLog(@"author node: %@", s );}
         */
        
        //GET media group for Description and thumbnail
        NSDictionary * media = [e objectForKey:@"media$group"];
        
        //SET DESCRIPTION
        NSDictionary * mediaDescription = [media objectForKey:@"media$description"];
        record.description=[mediaDescription objectForKey:@"$t"];
        
        //SET THUMBNAIL
        NSArray * thumbArray = [media objectForKey:@"media$thumbnail"];
        
        for(int j=0;j<[thumbArray count];++j){
            NSDictionary * thumb = [thumbArray objectAtIndex:j];
            NSString *thumbURL=[thumb objectForKey:@"url"];
            NSString *thumbYTName=[thumb objectForKey:@"yt$name"];
            if([thumbYTName  isEqual: @"hqdefault"]){
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:thumbURL]];
                UIImage *img = [[UIImage alloc] initWithData:data];
                record.thumbnailImage=img;
                break;
            }
        }
        
        //SET VIEW COUNT
        NSDictionary * ytStats = [e objectForKey:@"yt$statistics"];
        NSString *temp=[ytStats objectForKey:@"viewCount"];
        record.viewCount=[temp integerValue];
        
        //Add to array of records
        [_youTubeRecordArray addObject:record];
    }
    [self populateView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Needed for some combinations of iOS/devices/simulator
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
