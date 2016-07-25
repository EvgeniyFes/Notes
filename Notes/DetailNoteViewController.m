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
}

@synthesize selectedNote;

- (void)viewDidLoad{
    [super viewDidLoad];
    _btnPhoto.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _btnRemove.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _doneBtn.enabled = NO;
    sharedModel = [NoteModel sharedInstance];
    
    self.title = @"New Note";
    if(selectedNote != nil){
        
        _noteName.text = selectedNote.name;
        _noteText.text = selectedNote.text;
        [self showCorrectData];
    }else{
        [_noteName becomeFirstResponder];
        _lblDate.text = [DetailNoteViewController correctFormatForDate:[NSDate date]];
    }
    
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
    
    _scrollViewHeightConstraint.constant = keyboardFrame.size.height - _viewWithBtns.frame.size.height;
}
- (void)keyboardHidden:(NSNotification*)notification{
    _scrollViewHeightConstraint.constant = 0;
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
        NSLog(@"btnGellery picked");
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    UIAlertAction* btnCamera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        NSLog(@"btnCamera picked");
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:picker animated:YES completion:NULL];
    }];
    
    UIAlertAction* btnCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){}];
    [photoAlert addAction:btnGallery];
    [photoAlert addAction:btnCamera];
    [photoAlert addAction:btnCancel];
    
    photoAlert.popoverPresentationController.sourceView = self.view;
    [self.navigationController presentViewController:photoAlert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info{
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString* url = [info objectForKey:UIImagePickerControllerReferenceURL];
    NSLog(@"url - %@", url);
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)clickDone:(id)sender {
    _doneBtn.enabled = NO;
    
    if(selectedNote == nil){
        selectedNote = [sharedModel addNewNoteWithTitle:_noteName.text withTextNote:_noteText.text andImages:@[]];
        
    }else{
        [sharedModel editNoteWithTitle:_noteName.text withTextNote:_noteText.text andIndex:[selectedNote.identifier integerValue]];
    }
    
    [self showCorrectData];
    [self.view endEditing:YES];
}


@end
