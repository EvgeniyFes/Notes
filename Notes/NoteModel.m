//
//  NoteModel.m
//  Notes
//
//  Created by Евгений Фесь on 18.07.16.
//  Copyright © 2016 AM. All rights reserved.
//

#import "NoteModel.h"
#import "AppDelegate.h"
#import "ImageManager.h"

@implementation NoteModel{
    NSManagedObjectContext *context;
    NSMutableArray* allNotes;
    
    NSInteger biggestId;
}

+ (id)sharedInstance{
    static NoteModel* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NoteModel alloc] init];
        [sharedInstance loadFirstData];
    });
    return sharedInstance;
}


- (void)loadFirstData{
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    context = [delegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Note"];
    NSError *error = nil;
    
    allNotes = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    [self checkForBiggestId];
}

- (void)checkForBiggestId{
    biggestId = 0;
    for(Note* obj in allNotes){
        NSInteger identifier = [obj.identifier integerValue];
        biggestId = (biggestId > identifier) ? biggestId : ++identifier;
    }
}

- (NSInteger)idForImageInNote:(Note*)note{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"NoteImage"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"identifier == %li", [note.identifier integerValue]];
    [request setPredicate:predicate];
    
    NSInteger result = 0;
    NSArray* imagesAtNote = [context executeFetchRequest:request error:nil];
    for(NoteImage* obj in imagesAtNote){
        NSInteger identifier = [obj.identifier integerValue];
        result = (result > identifier) ? result : ++identifier;
    }
    
    return result;
}


- (NSArray*)allNotes{
    NSSortDescriptor* sortEdit = [[NSSortDescriptor alloc] initWithKey:@"dateEdit" ascending:NO];
    return [allNotes sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortEdit]];
}

- (NSArray*)noteImages{
    return @[];
}


#pragma mark Note Create
- (Note*)addNewNoteWithTitle:(NSString*)title withTextNote:(NSString*)text andImages:(NSArray*)imagesArray{
    Note* newNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    newNote.identifier = [NSNumber numberWithInteger:biggestId];
    newNote.name = title;
    newNote.text = text;
    newNote.dateCreate = [NSDate date];
    newNote.dateEdit = [NSDate date];
    
    for(NSDictionary* imageData in imagesArray){
        [self addImage:imageData toNote:newNote];
    }
    
    
    [context save:nil];
    [allNotes addObject:newNote];
    
    ++biggestId;
    
    return newNote;
}


#pragma mark Note Editing
- (void)editNoteWithTitle:(NSString*)title withTextNote:(NSString*)text andIndex:(NSInteger)index{
    for(Note* editNote in allNotes){
        if([editNote.identifier integerValue] == index){
            editNote.dateEdit = [NSDate date];
            editNote.name = title;
            editNote.text = text;
            
            [context save:nil];
        }
    }
}

- (void)addImage:(NSDictionary*)imageData toNote:(Note*)note{
    NoteImage* addImage = [NSEntityDescription insertNewObjectForEntityForName:@"NoteImage" inManagedObjectContext:context];
    addImage.imageUrl = [imageData objectForKey:@"url"];
    addImage.identifier = [NSNumber numberWithInteger:[self idForImageInNote:note]];
    addImage.parentID = [NSNumber numberWithInteger:[note.identifier integerValue]];
    
    [ImageManager saveImage:[imageData objectForKey:@"image"] filename:[imageData objectForKey:@"url"]];
    [context save:nil];
}


- (void)removeFromNote:(Note*)note imageWithUrl:(NSString *)url{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"NoteImage"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"identifier == %li", [note.identifier integerValue]];
    [request setPredicate:predicate];
    
    NSArray* imagesAtNote = [context executeFetchRequest:request error:nil];
    NoteImage* obj = [imagesAtNote firstObject];
    [ImageManager removeImage:obj.imageUrl];
    
    [context deleteObject:obj];
    [context save:nil];
}




#pragma mark Note Remote
- (void)removeNote:(Note*)note{
    [self removeImagesForNote:note];
    [context deleteObject:note];
    [context save:nil];
    
    [allNotes removeObject:note];
    [self checkForBiggestId];
}

- (void)removeImagesForNote:(Note*)note{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"NoteImage"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"identifier == %li", [note.identifier integerValue]];
    [request setPredicate:predicate];
    
    NSArray* imagesAtNote = [context executeFetchRequest:request error:nil];
    for(NoteImage* obj in imagesAtNote){
        [ImageManager removeImage:obj.imageUrl];
        [context deleteObject:obj];
    }
}


- (void)removeAll{
    for(Note* obj in allNotes)
        [context deleteObject:obj];
    
    [allNotes removeAllObjects];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"NoteImage"];
    NSArray* allImages = [context executeFetchRequest:request error:nil];
    for(NoteImage* obj in allImages){
        [ImageManager removeImage:obj.imageUrl];
        [context deleteObject:obj];
    }
    
    [context save:nil];
    biggestId = 0;
}

@end
