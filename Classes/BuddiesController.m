#import "BuddiesController.h"
#import "ChatController.h"
#import "GPNSObjectAdditions.h"
#import "Buddy.h"


@interface BuddiesController ()
@property(nonatomic,strong) NSArray *buddies;
@end

@implementation BuddiesController
@synthesize buddies, repository, botService;


#pragma mark
#pragma mark View lifecycle

- (void)loadView {
	[super loadView];
	self.title = @"Buddies";
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.buddies = [self.repository findBuddies];
	[self.tableView reloadData];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.botService = [[BotService alloc] init];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.buddies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BuddyCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	Buddy *buddy = [self.buddies objectAtIndex:indexPath.row];
    
	cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",buddy.name]];
	cell.textLabel.text = buddy.name;
	cell.detailTextLabel.text = buddy.lastMessage.text;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatController *chatController = [[ChatController alloc]init];
	Buddy *selectedbuddy = [self.buddies objectAtIndex:indexPath.row];
    
    chatController.repository = self.repository;
	chatController.buddy = selectedbuddy;
    chatController.botService = self.botService;
    
    [self.botService initWithBuddy:selectedbuddy];
	[self.navigationController pushViewController:chatController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 48;
}

@end

