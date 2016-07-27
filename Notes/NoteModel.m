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
    NSMutableArray* allImageID;
    NSMutableArray* imageIDforCurrNote;
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"name != nil"];
    [request setPredicate:predicate];
    NSError *error = nil;
    
    allNotes = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:&error]];
    allImageID = [[NSMutableArray alloc] init];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"NoteImage"];
    NSArray* allImages = [[NSMutableArray alloc] initWithArray:[context executeFetchRequest:request error:nil]];
    for(NoteImage* img in allImages)
        [allImageID addObject:img.imageID];
}


- (NSArray*)allNotes{
    NSSortDescriptor* sortEdit = [[NSSortDescriptor alloc] initWithKey:@"dateEdit" ascending:NO];
    return [allNotes sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortEdit]];
}

- (NSMutableArray*)imagesForNote:(Note*)note{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"NoteImage"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"parentNote == %@", note];
    [request setPredicate:predicate];
    
    NSArray* images = [context executeFetchRequest:request error:nil];
    NSMutableArray* imagesOriginal = [[NSMutableArray alloc] init];
    imageIDforCurrNote = [[NSMutableArray alloc] init];
    
    for(NoteImage* imgNote in images){
        [imageIDforCurrNote addObject:imgNote.imageID];
        [imagesOriginal addObject:[ImageManager getImage:[imgNote.imageID stringValue]]];
    }
    return imagesOriginal;
}



#pragma mark Note Create
- (Note*)addNewNoteWithTitle:(NSString*)title withTextNote:(NSString*)text{
    Note* newNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    newNote.name = title;
    newNote.text = text;
    newNote.dateCreate = [NSDate date];
    newNote.dateEdit = [NSDate date];
    
    
    [context save:nil];
    [allNotes addObject:newNote];
    return newNote;
}

- (void)addImage:(UIImage*)image toNote:(Note*)note{
    NoteImage* addImage = [NSEntityDescription insertNewObjectForEntityForName:@"NoteImage" inManagedObjectContext:context];
    
    addImage.imageID = [self specialImageID];
    addImage.parentNote = note;
    
    [context save:nil];
    
    [ImageManager saveImage:image filename:[addImage.imageID stringValue]];
    [imageIDforCurrNote addObject:addImage.imageID];
    [allImageID addObject:addImage.imageID];
}

- (NSNumber*)specialImageID{
    NSInteger maxNumber = [[allImageID valueForKeyPath:@"@max.intValue"] integerValue];
    NSNumber* nextImageID = [NSNumber numberWithInteger:++maxNumber];

    return nextImageID;
}


#pragma mark Note Editing
- (void)editNoteWithTitle:(NSString*)title withTextNote:(NSString*)text andNote:(Note*)editNote{
    editNote.dateEdit = [NSDate date];
    editNote.name = title;
    editNote.text = text;
            
    [context save:nil];
}



#pragma mark Note Remote
- (void)removeNote:(Note*)note{
    [self removeImagesForNote:note];
    [context deleteObject:note];
    [context save:nil];
    
    [allNotes removeObject:note];
}

- (void)removeFromNote:(Note*)note imageWithIndex:(NSInteger)index{
    NSNumber* imgID = imageIDforCurrNote[index];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"NoteImage"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"imageID == %@", imgID];
    [request setPredicate:predicate];
    
    NoteImage* obj = [[context executeFetchRequest:request error:nil] firstObject];
    [ImageManager removeImage:[obj.imageID stringValue]];
    
    [context deleteObject:obj];
    [context save:nil];
    
    [imageIDforCurrNote removeObjectAtIndex:index];
    [allImageID removeObjectAtIndex:index];
}

- (void)removeImagesForNote:(Note*)note{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"NoteImage"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"parentNote == %@", note];
    [request setPredicate:predicate];
    
    NSArray* imagesAtNote = [context executeFetchRequest:request error:nil];
    for(NoteImage* obj in imagesAtNote){
        [ImageManager removeImage:[obj.imageID stringValue]];
        [context deleteObject:obj];
    }
    [context save:nil];
}


- (void)removeAll{
    for(Note* obj in allNotes)
        [context deleteObject:obj];
    
    [allNotes removeAllObjects];
    [allImageID removeAllObjects];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"NoteImage"];
    NSArray* allNotesImages = [context executeFetchRequest:request error:nil];
    for(NoteImage* obj in allNotesImages){
        [ImageManager removeImage:[obj.imageID stringValue]];
        [context deleteObject:obj];
    }
    
    [context save:nil];
}

@end
