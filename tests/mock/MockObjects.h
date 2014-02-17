// MockObjects.h
//
// Created by Till Hagger on 17/02/14.

#import <Foundation/Foundation.h>


@class User;

typedef enum
{
    GenderNone,
    GenderFemale,
    GenderMale
} Gender;

@interface Comment : NSObject

@property (nonatomic) NSUInteger id;
@property (nonatomic) NSDate* createDate;

@property (nonatomic) User* user;

- (instancetype)initWithId:(NSUInteger)id
                createDate:(NSDate*)createDate
                      user:(User*)user;

@end

@interface User : NSObject

@property (nonatomic) NSUInteger id;
@property (nonatomic) NSString* idString;

@property (nonatomic) NSString* firstName;
@property (nonatomic) NSString* lastName;

@property (nonatomic) Gender gender;
@property (nonatomic) NSArray* comments;

- (instancetype)initWithId:(NSUInteger)id
                 firstName:(NSString*)firstName
                  lastName:(NSString*)lastName
                    gender:(Gender)gender
                  comments:(NSArray*)comments;

@end