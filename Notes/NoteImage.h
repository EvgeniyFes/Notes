//
//  NoteImage.h
//  Notes
//
//  Created by Евгений Фесь on 23.07.16.
//  Copyright © 2016 AM. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NoteImage : NSManagedObject

@property (nonatomic, retain) NSString* imageUrl;

@property (nonatomic, retain) NSNumber* identifier;
@property (nonatomic, retain) NSNumber* parentID;

@end
