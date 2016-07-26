//
//  NoteImage+CoreDataProperties.h
//  Notes
//
//  Created by Евгений Фесь on 25.07.16.
//  Copyright © 2016 AM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "NoteImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface NoteImage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) Note *parentNote;

@end

NS_ASSUME_NONNULL_END
