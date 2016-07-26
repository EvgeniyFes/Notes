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
#import "ScrollWithImages.h"

@interface DetailNoteViewController : UIViewController<UIScrollViewDelegate, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, ScrollWithImagesDelegate>

@property Note* selectedNote;

@property (weak, nonatomic) IBOutlet UIView *viewForScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *viewWithBtns;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;

@property (weak, nonatomic) IBOutlet UIButton *btnRemove;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;


@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UITextField *noteName;
@property (weak, nonatomic) IBOutlet UITextView *noteText;

+ (NSString*)correctFormatForDate:(NSDate*)date;

@end
