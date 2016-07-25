//
//  DetailNoteViewController.h
//  Notes
//
//  Created by Евгений Фесь on 18.07.16.
//  Copyright © 2016 AM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NoteModel.h"

@interface DetailNoteViewController : UIViewController<UIScrollViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate>

@property Note* selectedNote;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *viewWithBtns;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;

@property (weak, nonatomic) IBOutlet UIButton *btnRemove;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;


@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UITextField *noteName;
@property (weak, nonatomic) IBOutlet UITextView *noteText;

+ (NSString*)correctFormatForDate:(NSDate*)date;

@end
