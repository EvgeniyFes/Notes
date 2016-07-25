//
//  ViewController.h
//  Notes
//
//  Created by Евгений Фесь on 18.07.16.
//  Copyright © 2016 AM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"
#import "Note.h"

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *removeAllBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBtn;

@end

