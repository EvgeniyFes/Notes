//
//  NoteModel.h
//  Notes
//
//  Created by Евгений Фесь on 18.07.16.
//  Copyright © 2016 AM. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Note.h"
#import "NoteImage.h"

@interface NoteModel : NSObject

+ (id)sharedInstance;

- (NSArray*)allNotes;
- (Note*)addNewNoteWithTitle:(NSString*)title withTextNote:(NSString*)text andImages:(NSArray*)imagesArray;
- (void)editNoteWithTitle:(NSString*)title withTextNote:(NSString*)text andIndex:(NSInteger)index;

- (NSArray*)noteImages;
- (void)addImage:(NSDictionary*)imageData toNote:(Note*)note;
- (void)removeFromNote:(Note*)note imageWithUrl:(NSString*)url;


- (void)removeNote:(Note*)note;
- (void)removeAll;

@end
