//
//  Note+CoreDataProperties.h
//  Notes
//
//  Created by Евгений Фесь on 25.07.16.
//  Copyright © 2016 AM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *dateCreate;
@property (nullable, nonatomic, retain) NSDate *dateEdit;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *image;

@end

@interface Note (CoreDataGeneratedAccessors)

- (void)addImageObject:(NSManagedObject *)value;
- (void)removeImageObject:(NSManagedObject *)value;
- (void)addImage:(NSSet<NSManagedObject *> *)values;
- (void)removeImage:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
