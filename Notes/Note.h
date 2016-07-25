//
//  Note.h
//  Notes
//
//  Created by Евгений Фесь on 18.07.16.
//  Copyright © 2016 AM. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Note : NSManagedObject

@property (nonatomic, retain) NSDate* dateCreate;
@property (nonatomic, retain) NSDate* dateEdit;

@property (nonatomic, retain) NSString* image;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* text;

@property (nonatomic, retain) NSNumber* identifier;

@end
