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

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Type encoding's type.
 */
typedef NS_OPTIONS(NSUInteger, WXMFMDBEncodingType) {
    WXMFMDBEncodingTypeMask       = 0xFF, ///< mask of type value
    WXMFMDBEncodingTypeUnknown    = 0, ///< unknown
    WXMFMDBEncodingTypeVoid       = 1, ///< void
    WXMFMDBEncodingTypeBool       = 2, ///< bool
    WXMFMDBEncodingTypeInt8       = 3, ///< char / BOOL
    WXMFMDBEncodingTypeUInt8      = 4, ///< unsigned char
    WXMFMDBEncodingTypeInt16      = 5, ///< short
    WXMFMDBEncodingTypeUInt16     = 6, ///< unsigned short
    WXMFMDBEncodingTypeInt32      = 7, ///< int
    WXMFMDBEncodingTypeUInt32     = 8, ///< unsigned int
    WXMFMDBEncodingTypeInt64      = 9, ///< long long
    WXMFMDBEncodingTypeUInt64     = 10, ///< unsigned long long
    WXMFMDBEncodingTypeFloat      = 11, ///< float
    WXMFMDBEncodingTypeDouble     = 12, ///< double
    WXMFMDBEncodingTypeLongDouble = 13, ///< long double
    WXMFMDBEncodingTypeObject     = 14, ///< id
    WXMFMDBEncodingTypeClass      = 15, ///< Class
    WXMFMDBEncodingTypeSEL        = 16, ///< SEL
    WXMFMDBEncodingTypeBlock      = 17, ///< block
    WXMFMDBEncodingTypePointer    = 18, ///< void*
    WXMFMDBEncodingTypeStruct     = 19, ///< struct
    WXMFMDBEncodingTypeUnion      = 20, ///< union
    WXMFMDBEncodingTypeCString    = 21, ///< char*
    WXMFMDBEncodingTypeCArray     = 22, ///< char[10] (for example)
    
    WXMFMDBEncodingTypeQualifierMask   = 0xFF00,   ///< mask of qualifier
    WXMFMDBEncodingTypeQualifierConst  = 1 << 8,  ///< const
    WXMFMDBEncodingTypeQualifierIn     = 1 << 9,  ///< in
    WXMFMDBEncodingTypeQualifierInout  = 1 << 10, ///< inout
    WXMFMDBEncodingTypeQualifierOut    = 1 << 11, ///< out
    WXMFMDBEncodingTypeQualifierBycopy = 1 << 12, ///< bycopy
    WXMFMDBEncodingTypeQualifierByref  = 1 << 13, ///< byref
    WXMFMDBEncodingTypeQualifierOneway = 1 << 14, ///< oneway
    
    WXMFMDBEncodingTypePropertyMask         = 0xFF0000, ///< mask of property
    WXMFMDBEncodingTypePropertyReadonly     = 1 << 16, ///< readonly
    WXMFMDBEncodingTypePropertyCopy         = 1 << 17, ///< copy
    WXMFMDBEncodingTypePropertyRetain       = 1 << 18, ///< retain
    WXMFMDBEncodingTypePropertyNonatomic    = 1 << 19, ///< nonatomic
    WXMFMDBEncodingTypePropertyWeak         = 1 << 20, ///< weak
    WXMFMDBEncodingTypePropertyCustomGetter = 1 << 21, ///< getter=
    WXMFMDBEncodingTypePropertyCustomSetter = 1 << 22, ///< setter=
    WXMFMDBEncodingTypePropertyDynamic      = 1 << 23, ///< @dynamic
};

/**
 Get the type from a Type-Encoding string.
 
 @discussion See also:
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
 https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
 
 @param typeEncoding  A Type-Encoding string.
 @return The encoding type.
 */
WXMFMDBEncodingType WXMFMDBEncodingGetType(const char *typeEncoding);


/**
 Instance variable information.
 */
@interface WXMFMDBClassIvarInfo : NSObject
@property (nonatomic, assign, readonly) Ivar ivar; ///< ivar
@property (nonatomic, strong, readonly) NSString *name; ///< Ivar's name
@property (nonatomic, assign, readonly) ptrdiff_t offset; ///< Ivar's offset
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< Ivar's type encoding
@property (nonatomic, assign, readonly) WXMFMDBEncodingType type; ///< Ivar's type
- (instancetype)initWithIvar:(Ivar)ivar;
@end

/**
 Method information.
 */
@interface WXMFMDBClassMethodInfo : NSObject
@property (nonatomic, assign, readonly) Method method; ///< method
@property (nonatomic, strong, readonly) NSString *name; ///< method name
@property (nonatomic, assign, readonly) SEL sel; ///< method's selector
@property (nonatomic, assign, readonly) IMP imp; ///< method's implementation
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< method's parameter and return types
@property (nonatomic, strong, readonly) NSString *returnTypeEncoding; ///< return value's type
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *argumentTypeEncodings; ///< array of arguments' type
- (instancetype)initWithMethod:(Method)method;
@end

/**
 Property information.
 */
@interface WXMFMDBClassPropertyInfo : NSObject
@property (nonatomic, assign, readonly) objc_property_t property; ///< property
@property (nonatomic, strong, readonly) NSString *name; ///< property's name
@property (nonatomic, assign, readonly) WXMFMDBEncodingType type; ///< property's type
@property (nonatomic, strong, readonly) NSString *typeEncoding; ///< property's encoding value
@property (nonatomic, strong, readonly) NSString *ivarName; ///< property's ivar name
@property (nullable, nonatomic, assign, readonly) Class cls; ///< may be nil
@property (nonatomic, assign, readonly) SEL getter; ///< getter (nonnull)
@property (nonatomic, assign, readonly) SEL setter; ///< setter (nonnull)
- (instancetype)initWithProperty:(objc_property_t)property;
@end

/**
 Class information for a class.
 */
@interface WXMFMDBClassInfo : NSObject
@property (nonatomic, assign, readonly) Class cls; ///< class object
@property (nullable, nonatomic, assign, readonly) Class superCls; ///< super class object
@property (nullable, nonatomic, assign, readonly) Class metaCls;  ///< class's meta class object
@property (nonatomic, readonly) BOOL isMeta; ///< whether this class is meta class
@property (nonatomic, strong, readonly) NSString *name; ///< class name
@property (nullable, nonatomic, strong, readonly) WXMFMDBClassInfo *superClassInfo; ///< super class's class info
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, WXMFMDBClassIvarInfo *> *ivarInfos; ///< ivars
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, WXMFMDBClassMethodInfo *> *methodInfos; ///< methods
@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, WXMFMDBClassPropertyInfo *> *propertyInfos; ///< properties

/**
 If the class is changed (for example: you add a method to this class with
 'class_addMethod()'), you should call this method to refresh the class info cache.
 
 After called this method, you may call 'classInfoWithClass' or 
 'classInfoWithClassName' to get the updated class info.
 */
- (void)setNeedUpdate;

/**
 If this method returns `YES`, you should stop using this instance and call
 `classInfoWithClass` or `classInfoWithClassName` to get the updated class info.
 
 @return Whether this class info need update.
 */
- (BOOL)needUpdate;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param cls A class.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClass:(Class)cls;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param className A class name.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClassName:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
