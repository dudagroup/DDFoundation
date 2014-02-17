// MockObjects.m
//
// Created by Till Hagger on 17/02/14.

#import "MockObjects.h"


#define IS_EQUAL(x,y) ((x && [x isEqual:y]) || (!x && !y))

@implementation Comment

- (instancetype)initWithId:(NSUInteger)id
                createDate:(NSDate*)createDate
                      user:(User*)user
{
    self = [super init];

    if (self)
    {
        _id = id;
        _createDate = createDate;
        _user = user;
    }

    return self;
}


- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[Comment class]])
    {
        Comment* comment = object;

        return IS_EQUAL(self.createDate, comment.createDate) &&
               IS_EQUAL(self.user, comment.user) &&
               self.id == comment.id;
    }

    return NO;
}

@end

@implementation User

- (instancetype)initWithId:(NSUInteger)id
                 firstName:(NSString*)firstName
                  lastName:(NSString*)lastName
                    gender:(Gender)gender
                  comments:(NSArray*)comments
{
    self = [super init];

    if (self)
    {
        _id = id;
        _firstName = firstName;
        _lastName = lastName;
        _gender = gender;
        _comments = comments;
    }

    return self;
}


- (BOOL)isEqual:(id)object
{
    if ([object isKindOfClass:[User class]])
    {
        User* user = object;

        return IS_EQUAL(self.firstName, user.firstName) &&
               IS_EQUAL(self.lastName, user.lastName) &&
               IS_EQUAL(self.comments, user.comments) &&
               self.id == user.id &&
               self.gender == user.gender;
    }

    return NO;
}

@end