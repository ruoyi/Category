//
//  Foundation+Extension.m
//  dailycare
//
//  Created by 若懿 on 15/12/16.
//  Copyright © 2015年 ruoyi. All rights reserved.
//

#import "Foundation+RYTool.h"


@implementation NSString (RYTool)

- (NSString *)ry_stringByURLEncoding
{
	return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]];
}

- (BOOL)ry_validatePhoneNumber {
	NSString *phoneRegex = @"1[3|4|5|6|7|8|][0-9]{9}";
	NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
	return [phoneTest evaluateWithObject:self];

}

//验证英文数字
- (BOOL)ry_validateNumEngWithMinLength:(NSUInteger)min maxLength:(NSUInteger)max {
	NSString *regex = [NSString stringWithFormat:@"[A-Z0-9a-z]{%@,%@}", @(min), @(max)];
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
	return [pred evaluateWithObject:self];
}


@end

@implementation NSArray (RYTool)

- (NSArray *)ry_safeSubarrayWithRange:(NSRange)range {
    if ( 0 == self.count )
        return nil;
    
    if ( range.location >= self.count )
        return nil;
    
    if ( range.location + range.length >= self.count )
        return nil;
    
    return [self subarrayWithRange:NSMakeRange(range.location, range.length)];
}

+ (NSArray *)ry_safeArrayWithObject:(id)object {
    if (!object) {
        return @[];
    }
    
    return [NSArray arrayWithObject:object];
}

- (id)ry_find:(BOOL(^)(id obj))block {
    __block id ret = nil;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj)) {
            *stop = YES;
            ret = obj;
        }
    }];
    return ret;
}
@end




@implementation NSDictionary (RYTool)

- (NSDictionary *)ry_changeKeyFrom:(id)fromkey toKey:(id)tokey {
	if (nil == fromkey|| nil == tokey || [fromkey isEqual:tokey]) {
		return self;
	}
	return [self ry_matchKeys:@[fromkey] tokey:tokey];
}

- (NSDictionary *)ry_matchKeys:(NSArray *)matchKeys tokey:(id)tokey {
	for (id formKey in matchKeys) {
		if ([self objectForKey:formKey]) {
			return [self ry_matchKeyInfo:@{formKey:tokey}];
		}
	}
	return self;
}

- (NSDictionary *)ry_matchKeyInfo:(NSDictionary *)keyInfo {

	NSMutableDictionary *tempDic = [self mutableCopy];
	for (id key in [keyInfo allKeys]) {
		if ([self objectForKey:key]) {
			[tempDic removeObjectForKey:key];
			[tempDic setObject:self[key] forKey:keyInfo[key]];
		}
	}
	return tempDic;
}

@end


@implementation NSMutableDictionary (RYTool)
- (void)ry_safeSetObject:(id)anObject forKey:(id <NSCopying>)aKey {
	if (!anObject) {
		return;
	}

	[self setObject:anObject forKey:aKey];
}
@end


@implementation NSDate (RYTool)

- (NSDate *)ry_dateByAddingDays: (NSInteger) dDays
{
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	[dateComponents setDay:dDays];
	NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
	return newDate;
}

@end




