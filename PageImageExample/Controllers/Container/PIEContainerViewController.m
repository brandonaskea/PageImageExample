//
//  PIEContainerViewController.m
//  PageImageExample
//
//  Created by Brandon Askea on 2/18/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

#import "PIEContainerViewController.h"
#import "PageImageExample-Swift.h"


@interface PIEContainerViewController: UITableViewController <PIEMainPageViewControllerDelegate>

@property (weak, nonatomic) PIEMainPageViewController *mainPageVC;

@end

@implementation PIEContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
        Configure Table view with
        UIRefreshControl
    */
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl setTintColor:[UIColor whiteColor]];
    
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin)];

    self.tableView.backgroundView.backgroundColor = UIColor.blackColor;
    self.tableView.backgroundColor = UIColor.blackColor;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqualToString: @"container"]) {
        self.mainPageVC = segue.destinationViewController;
        self.mainPageVC.del = self;
        
    }
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UIScreen.mainScreen.bounds.size.height;
}

#pragma mark - Pull to refresh

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    /*
        Pull-To-Refresh
        When the user drags downward beyond
        the threshold, send a notification
        to Pull-To-Refresh the content.
    */
    if (scrollView.contentOffset.y < -80) {
        self.refreshControl.alpha = 1;
        [self.mainPageVC refresh];
    }
}


- (void)didFinishRefreshing {
    self.refreshControl.alpha = 0;
    self.tableView.contentOffset = CGPointZero;
}

@end
