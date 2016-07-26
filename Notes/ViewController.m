//
//  ViewController.m
//  Notes
//
//  Created by Евгений Фесь on 18.07.16.
//  Copyright © 2016 AM. All rights reserved.
//

#import "ViewController.h"
#import "DetailNoteViewController.h"

@interface ViewController (){
    NoteModel* sharedNote;
    NSArray *notesArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    sharedNote = [NoteModel sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _table.editing = NO;
    [_table reloadData];
}


#pragma mark TableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    notesArray = [sharedNote allNotes];
    _removeAllBtn.enabled = (notesArray.count > 0) ? YES : NO;
    _editBtn.enabled = (notesArray.count > 0) ? YES : NO;
    return notesArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    Note* currentNote = [notesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = ([currentNote.name isEqualToString:@""]) ? @"(No title)" : currentNote.name;
    
    NSDate* showDate = currentNote.dateEdit;
    cell.detailTextLabel.text = [DetailNoteViewController correctFormatForDate:showDate];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailNoteViewController* nextController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailNoteViewController"];
    nextController.selectedNote = notesArray[indexPath.row];
    [self.navigationController pushViewController:nextController animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [sharedNote removeNote:[notesArray objectAtIndex:indexPath.row]];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    notesArray = [sharedNote allNotes];
}



- (IBAction)removeAllNotes:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Remove all notes?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesBtn = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [sharedNote removeAll];
        
        _table.editing = NO;
        [_table reloadData];
    }];
    UIAlertAction* noBtn = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){}];
    [alert addAction:yesBtn];
    [alert addAction:noBtn];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)clickEdit:(id)sender {
    _table.editing = !_table.editing;
}
@end
