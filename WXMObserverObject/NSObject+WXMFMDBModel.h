//
//  WXMFMDBClassInfo.h
//  WXMFMDBKit <https://github.com/ibireme/WXMFMDBKit>
//
//  Created by ibireme on 15/5/9.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"model key" : @"json key" };
//}

//+ (NSDictionary *)modelContainerPropertyGenericClass {
//    return @{@"json key" : [xxModel class]};
//}

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 此类为YYModel 做了一点修改 */
@interface NSObject (WXMFMDBModel)

/** json转模型 */
+ (nullable instancetype)modelWithJSON:(id)json;

/** 字典转模型 */
+ (nullable instancetype)modelWithDictionary:(NSDictionary *)dictionary;

/** model转字典 */
- (nullable id)modelToJSONObject;

/** 深拷贝 */
- (nullable id)modelCopy;

/** model是否一致 */
- (BOOL)modelIsEqual:(id)model;

/** 是否可以转json */
- (BOOL)modelSetWithJSON:(id)json;
- (BOOL)modelSetWithDictionary:(NSDictionary *)dic;

/** model转data或者json */
- (nullable NSData *)modelToJSONData;
- (nullable NSString *)modelToJSONString;

- (void)modelEncodeWithCoder:(NSCoder *)aCoder;
- (id)modelInitWithCoder:(NSCoder *)aDecoder;

/** model哈希值 */
- (NSUInteger)modelHash;

/** model属性 */
- (NSString *)modelDescription;
@end

@interface NSArray (WXMFMDBModel)

/** 字典数组转模型数组 */
+ (nullable NSArray *)modelArrayWithClass:(Class)cls json:(id)json;

@end

@protocol WXMFMDBModel <NSObject>
@optional
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper;
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass;
+ (nullable Class)modelCustomClassForDictionary:(NSDictionary *)dictionary;
+ (nullable NSArray<NSString *> *)modelPropertyBlacklist;
+ (nullable NSArray<NSString *> *)modelPropertyWhitelist;
- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic;
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic;
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic;
@end

typedef NS_OPTIONS(NSUInteger, WXMFMDBEncodingType) {
    WXMFMDBEncodingTypeMask       = 0xFF,
    WXMFMDBEncodingTypeUnknown    = 0,
    WXMFMDBEncodingTypeVoid       = 1,
    WXMFMDBEncodingTypeBool       = 2,
    WXMFMDBEncodingTypeInt8       = 3,
    WXMFMDBEncodingTypeUInt8      = 4,
    WXMFMDBEncodingTypeInt16      = 5,
    WXMFMDBEncodingTypeUInt16     = 6,
    WXMFMDBEncodingTypeInt32      = 7,
    WXMFMDBEncodingTypeUInt32     = 8,
    WXMFMDBEncodingTypeInt64      = 9,
    WXMFMDBEncodingTypeUInt64     = 10,
    WXMFMDBEncodingTypeFloat      = 11,
    WXMFMDBEncodingTypeDouble     = 12,
    WXMFMDBEncodingTypeLongDouble = 13,
    WXMFMDBEncodingTypeObject     = 14,
    WXMFMDBEncodingTypeClass      = 15,
    WXMFMDBEncodingTypeSEL        = 16,
    WXMFMDBEncodingTypeBlock      = 17,
    WXMFMDBEncodingTypePointer    = 18,
    WXMFMDBEncodingTypeStruct     = 19,
    WXMFMDBEncodingTypeUnion      = 20,
    WXMFMDBEncodingTypeCString    = 21,
    WXMFMDBEncodingTypeCArray     = 22,
    
    WXMFMDBEncodingTypeQualifierMask   = 0xFF00,
    WXMFMDBEncodingTypeQualifierConst  = 1 << 8,
    WXMFMDBEncodingTypeQualifierIn     = 1 << 9,
    WXMFMDBEncodingTypeQualifierInout  = 1 << 10,
    WXMFMDBEncodingTypeQualifierOut    = 1 << 11,
    WXMFMDBEncodingTypeQualifierBycopy = 1 << 12,
    WXMFMDBEncodingTypeQualifierByref  = 1 << 13,
    WXMFMDBEncodingTypeQualifierOneway = 1 << 14,
    
    WXMFMDBEncodingTypePropertyMask         = 0xFF0000,
    WXMFMDBEncodingTypePropertyReadonly     = 1 << 16,
    WXMFMDBEncodingTypePropertyCopy         = 1 << 17,
    WXMFMDBEncodingTypePropertyRetain       = 1 << 18,
    WXMFMDBEncodingTypePropertyNonatomic    = 1 << 19,
    WXMFMDBEncodingTypePropertyWeak         = 1 << 20,
    WXMFMDBEncodingTypePropertyCustomGetter = 1 << 21,
    WXMFMDBEncodingTypePropertyCustomSetter = 1 << 22,
    WXMFMDBEncodingTypePropertyDynamic      = 1 << 23,
};

WXMFMDBEncodingType WXMFMDBEncodingGetType(const char *typeEncoding);
@interface WXMFMDBClassIvarInfo : NSObject
@property (nonatomic, assign, readonly) Ivar ivar;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) ptrdiff_t offset;
@property (nonatomic, strong, readonly) NSString *typeEncoding;
@property (nonatomic, assign, readonly) WXMFMDBEncodingType type;
- (instancetype)initWithIvar:(Ivar)ivar;
@end

@interface WXMFMDBClassMethodInfo : NSObject
@property (nonatomic, assign, readonly) Method method;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) SEL sel;
@property (nonatomic, assign, readonly) IMP imp;
@property (nonatomic, strong, readonly) NSString *typeEncoding;
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding;
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *argumentTypeEncodings;
- (instancetype)initWithMethod:(Method)method;
@end

@interface WXMFMDBClassPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) WXMFMDBEncodingType type;
@property (nonatomic, strong, readonly) NSString *typeEncoding;
@property (nonatomic, strong, readonly) NSString *ivarName;
@property (nullable, nonatomic, assign, readonly) Class cls;
@property (nonatomic, assign, readonly) SEL getter;
@property (nonatomic, assign, readonly) SEL setter;
- (instancetype)initWithProperty:(objc_property_t)property;
@end

@interface WXMFMDBClassInfo : NSObject
@property (nonatomic, assign, readonly) Class cls;
@property (nullable, nonatomic, assign, readonly) Class superCls;
@property (nullable, nonatomic, assign, readonly) Class metaCls;
@property (nonatomic, readonly) BOOL isMeta;
@property (nonatomic, strong, readonly) NSString *name;
@property (nullable,nonatomic,strong, readonly) WXMFMDBClassInfo *superClassInfo;
@property (nullable,nonatomic,strong) NSDictionary<NSString *,WXMFMDBClassIvarInfo *>*ivarInfos;
@property (nullable,nonatomic,strong) NSDictionary<NSString *,WXMFMDBClassMethodInfo *>*methodInfos;
@property (nullable,nonatomic,strong) NSDictionary<NSString *,WXMFMDBClassPropertyInfo*>*propertyInfos;

- (void)setNeedUpdate;
- (BOOL)needUpdate;
+ (nullable instancetype)classInfoWithClass:(Class)cls;
+ (nullable instancetype)classInfoWithClassName:(NSString *)className;
@end


NS_ASSUME_NONNULL_END
