//
//  DetailNoteViewController.m
//  Notes
//
//  Created by Евгений Фесь on 18.07.16.
//  Copyright © 2016 AM. All rights reserved.
//

#import "DetailNoteViewController.h"


@implementation DetailNoteViewController{
    NoteModel* sharedModel;
    UIImagePickerController *picker;
    NSMutableArray* allImages;
    ScrollWithImages* scrollImage;
}

@synthesize selectedNote;

- (void)viewDidLoad{
    [super viewDidLoad];
    _btnPhoto.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _btnRemove.imageView.contentMode = UIViewContentModeScaleAspectFit;
    allImages = [[NSMutableArray alloc] init];
    
    _doneBtn.enabled = NO;
    sharedModel = [NoteModel sharedInstance];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    scrollImage = [[ScrollWithImages alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 100)];
    scrollImage.delegate = self;
    [_viewForScrollView addSubview:scrollImage];
    
    self.title = @"New Note";
    if(selectedNote != nil){
        
        _noteName.text = selectedNote.name;
        _noteText.text = selectedNote.text;
        [self showCorrectData];
        allImages = [sharedModel imagesForNote:selectedNote];
        [scrollImage showImages:allImages];
    }else{
        [_noteName becomeFirstResponder];
        _lblDate.text = [DetailNoteViewController correctFormatForDate:[NSDate date]];
    }
    _viewHeightConstraint.constant = (allImages.count > 0) ? 100 : 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardVisible:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardDidHideNotification object:nil];
}


- (void)showCorrectData{
    NSDate* dateForLbl = selectedNote.dateEdit;
    _lblDate.text = [DetailNoteViewController correctFormatForDate:dateForLbl];
    self.title = ([selectedNote.name isEqualToString:@""]) ? @"(No title)" : selectedNote.name;
}


+ (NSString*)correctFormatForDate:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm dd.MM.YYYY"];
    return [formatter stringFromDate:date];
}




#pragma mark text field/view methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    _doneBtn.enabled = YES;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    _doneBtn.enabled = YES;
}



#pragma mark keyboard methods
- (void)keyboardVisible:(NSNotification*)notification{
    NSDictionary *info = notification.userInfo;
    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    CGRect rawFrame = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    _viewHeightConstraint.constant = keyboardFrame.size.height - _viewWithBtns.frame.size.height;
}
- (void)keyboardHidden:(NSNotification*)notification{
    _viewHeightConstraint.constant = (allImages.count > 0) ? 100 : 0;
}




- (IBAction)clickRemoveNote:(id)sender {
    if(selectedNote != nil)
        [sharedModel removeNote:selectedNote];
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark Add Photo
- (IBAction)clickAddPhoto:(id)sender {
    UIAlertController* photoAlert = [UIAlertController alertControllerWithTitle:@"Add photo from:" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* btnGallery = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    UIAlertAction* btnCamera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    UIAlertAction* btnCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){}];
    [photoAlert addAction:btnGallery];
    [photoAlert addAction:btnCamera];
    [photoAlert addAction:btnCancel];
    
    photoAlert.popoverPresentationController.sourceView = _btnPhoto;
    photoAlert.popoverPresentationController.sourceRect = _btnPhoto.bounds;
    [self presentViewController:photoAlert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self saveNote];
    
    [sharedModel addImage:image toNote:selectedNote];
    _viewHeightConstraint.constant = 100;
    
    [allImages addObject:image];
    [scrollImage showImages:allImages];
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)clickDone:(id)sender {
    [self saveNote];
}


- (void)saveNote{
    _doneBtn.enabled = NO;
    
    if(selectedNote == nil){
        selectedNote = [sharedModel addNewNoteWithTitle:_noteName.text withTextNote:_noteText.text];
        
    }else{
        [sharedModel editNoteWithTitle:_noteName.text withTextNote:_noteText.text andNote:selectedNote];
    }
    
    [self showCorrectData];
    [self.view endEditing:YES];
}


#pragma mark ScrollWithImages Delegate
- (void)removeImageWithIndex:(NSInteger)index{
    [sharedModel removeFromNote:selectedNote imageWithIndex:index];
    [allImages removeObjectAtIndex:index];
    [scrollImage showImages:allImages];
    _viewHeightConstraint.constant = (allImages.count > 0) ? 100 : 0;
}


@end
