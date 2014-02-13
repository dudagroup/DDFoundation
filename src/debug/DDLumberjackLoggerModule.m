// DDCollectable.h
//
// Created by Till Hagger on 20/12/13.
// Copyright (c) 2013 DU DA. All rights reserved.

#import "DDLumberjackLoggerModule.h"


static NSString* const TextCellIdentifier = @"text";

@implementation DDLumberjackLoggerModule
{
    NSMutableArray* _messages;
    UITableView* _tableView;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _preferredModuleHeight = 200.0f;
        _maxLogMessages = 50;

        _messages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)logMessage:(DDLogMessage*)logMessage
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [_messages addObject:logMessage];
        if (_messages.count > _maxLogMessages)
        {
            [_messages removeObjectAtIndex:0];
        }

        [_tableView reloadData];
    });
}

- (void)loadView
{
    [super loadView];

    _tableView = [[UITableView alloc] init];

    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [_tableView registerClass:[UITableViewCell class]
       forCellReuseIdentifier:TextCellIdentifier];

    _tableView.dataSource = self;
    _tableView.delegate = self;

    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                                  UIViewAutoresizingFlexibleHeight;

    _tableView.frame = self.view.bounds;

    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messages count];
}

- (NSAttributedString*)formattedMessageStringForMessage:(DDLogMessage*)message
{
    /*if ([_messagesExpanded containsObject:@(indexPath.row)])
    {
        return [NSString stringWithFormat:@"[%@] %s:%d [%s]", [_dateFormatter stringFromDate:message->timestamp], message->file, message->lineNumber, message->function];
    }
    else
    {
        return [NSString stringWithFormat:@"[%@] %@", [_dateFormatter stringFromDate:message->timestamp], message->logMsg];
    }*/

    return [[NSAttributedString alloc] initWithString:message->logMsg];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:TextCellIdentifier
                                                            forIndexPath:indexPath];

    DDLogMessage* message = _messages[indexPath.row];

    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.attributedText = [self formattedMessageStringForMessage:message];
    cell.textLabel.font = [UIFont systemFontOfSize:11.0f];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.numberOfLines = 0;

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    DDLogMessage* message = _messages[indexPath.row];
    NSAttributedString* formattedMessage = [self formattedMessageStringForMessage:message];

    CGRect rect = [formattedMessage boundingRectWithSize:CGSizeMake(_tableView.frame.size.width, CGFLOAT_MAX)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                 context:NULL];

    return rect.size.height;
}

@end
