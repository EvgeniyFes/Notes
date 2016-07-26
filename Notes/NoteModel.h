//
//  NoteModel.h
//  Notes
//
//  Created by Евгений Фесь on 18.07.16.
//  Copyright © 2016 AM. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Note+CoreDataProperties.h"
#import "NoteImage+CoreDataProperties.h"

@interface NoteModel : NSObject

+ (id)sharedInstance;

- (NSArray*)allNotes;
- (Note*)addNewNoteWithTitle:(NSString*)title withTextNote:(NSString*)text;
- (void)editNoteWithTitle:(NSString*)title withTextNote:(NSString*)text andNote:(Note*)editNote;

- (NSMutableArray*)imagesForNote:(Note*)note;
- (void)addImage:(NSDictionary*)imageData toNote:(Note*)note;
- (void)removeFromNote:(Note*)note imageWithIndex:(NSInteger)index;


- (void)removeNote:(Note*)note;
- (void)removeAll;

@end
