//
//  TestListController.m
//  TestDemo
//
//  Created by Fantasy on 16/9/8.
//  Copyright © 2016年 fantasy. All rights reserved.
//

#import "TestListController.h"
#import "TextFieldTestController.h"
#import "VideoRecordController.h"
#import "MergeController.h"

@interface TestListController ()
{
    NSMutableDictionary *classMaps;
    NSMutableArray *titles;
}
@end

@implementation TestListController

- (void)viewDidLoad {
    [super viewDidLoad];
    classMaps = [[NSMutableDictionary alloc] init];
    titles = [[NSMutableArray alloc] init];
    [self addListItem:@"UITextField" className:NSStringFromClass([TextFieldTestController class])];
    [self addListItem:@"Merge Video" className:NSStringFromClass([MergeController class])];
    [self addListItem:@"Record" className:NSStringFromClass([VideoRecordController class])];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [titles count];
}

- (void) addListItem:(NSString *)title className:(NSString *)className {
    if (title == nil || className == nil) {
        return;
    }
    [titles addObject:title];
    [classMaps setObject:className forKey:title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testListCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [classMaps objectForKey:cell.textLabel.text];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = [classMaps objectForKey:[titles objectAtIndex:indexPath.row]];
    if (className == nil) {
        return;
    }
    
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:className];
    if (controller == nil) {
        controller = [[NSClassFromString(className) init] alloc];
    }
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
