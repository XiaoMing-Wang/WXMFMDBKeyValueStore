//
//  WXMFMDBClassInfo.m
//  WXMFMDBKit <https://github.com/ibireme/WXMFMDBKit>
//
//  Created by ibireme on 15/5/9.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "WXMFMDBClassInfo.h"
#import <objc/runtime.h>

WXMFMDBEncodingType WXMFMDBEncodingGetType(const char *typeEncoding) {
    char *type = (char *)typeEncoding;
    if (!type) return WXMFMDBEncodingTypeUnknown;
    size_t len = strlen(type);
    if (len == 0) return WXMFMDBEncodingTypeUnknown;
    
    WXMFMDBEncodingType qualifier = 0;
    bool prefix = true;
    while (prefix) {
        switch (*type) {
            case 'r': {
                qualifier |= WXMFMDBEncodingTypeQualifierConst;
                type++;
            } break;
            case 'n': {
                qualifier |= WXMFMDBEncodingTypeQualifierIn;
                type++;
            } break;
            case 'N': {
                qualifier |= WXMFMDBEncodingTypeQualifierInout;
                type++;
            } break;
            case 'o': {
                qualifier |= WXMFMDBEncodingTypeQualifierOut;
                type++;
            } break;
            case 'O': {
                qualifier |= WXMFMDBEncodingTypeQualifierBycopy;
                type++;
            } break;
            case 'R': {
                qualifier |= WXMFMDBEncodingTypeQualifierByref;
                type++;
            } break;
            case 'V': {
                qualifier |= WXMFMDBEncodingTypeQualifierOneway;
                type++;
            } break;
            default: { prefix = false; } break;
        }
    }

    len = strlen(type);
    if (len == 0) return WXMFMDBEncodingTypeUnknown | qualifier;

    switch (*type) {
        case 'v': return WXMFMDBEncodingTypeVoid | qualifier;
        case 'B': return WXMFMDBEncodingTypeBool | qualifier;
        case 'c': return WXMFMDBEncodingTypeInt8 | qualifier;
        case 'C': return WXMFMDBEncodingTypeUInt8 | qualifier;
        case 's': return WXMFMDBEncodingTypeInt16 | qualifier;
        case 'S': return WXMFMDBEncodingTypeUInt16 | qualifier;
        case 'i': return WXMFMDBEncodingTypeInt32 | qualifier;
        case 'I': return WXMFMDBEncodingTypeUInt32 | qualifier;
        case 'l': return WXMFMDBEncodingTypeInt32 | qualifier;
        case 'L': return WXMFMDBEncodingTypeUInt32 | qualifier;
        case 'q': return WXMFMDBEncodingTypeInt64 | qualifier;
        case 'Q': return WXMFMDBEncodingTypeUInt64 | qualifier;
        case 'f': return WXMFMDBEncodingTypeFloat | qualifier;
        case 'd': return WXMFMDBEncodingTypeDouble | qualifier;
        case 'D': return WXMFMDBEncodingTypeLongDouble | qualifier;
        case '#': return WXMFMDBEncodingTypeClass | qualifier;
        case ':': return WXMFMDBEncodingTypeSEL | qualifier;
        case '*': return WXMFMDBEncodingTypeCString | qualifier;
        case '^': return WXMFMDBEncodingTypePointer | qualifier;
        case '[': return WXMFMDBEncodingTypeCArray | qualifier;
        case '(': return WXMFMDBEncodingTypeUnion | qualifier;
        case '{': return WXMFMDBEncodingTypeStruct | qualifier;
        case '@': {
            if (len == 2 && *(type + 1) == '?')
                return WXMFMDBEncodingTypeBlock | qualifier;
            else
                return WXMFMDBEncodingTypeObject | qualifier;
        }
        default: return WXMFMDBEncodingTypeUnknown | qualifier;
    }
}

@implementation WXMFMDBClassIvarInfo

- (instancetype)initWithIvar:(Ivar)ivar {
    if (!ivar) return nil;
    self = [super init];
    _ivar = ivar;
    const char *name = ivar_getName(ivar);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    _offset = ivar_getOffset(ivar);
    const char *typeEncoding = ivar_getTypeEncoding(ivar);
    if (typeEncoding) {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
        _type = WXMFMDBEncodingGetType(typeEncoding);
    }
    return self;
}

@end

@implementation WXMFMDBClassMethodInfo

- (instancetype)initWithMethod:(Method)method {
    if (!method) return nil;
    self = [super init];
    _method = method;
    _sel = method_getName(method);
    _imp = method_getImplementation(method);
    const char *name = sel_getName(_sel);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    const char *typeEncoding = method_getTypeEncoding(method);
    if (typeEncoding) {
        _typeEncoding = [NSString stringWithUTF8String:typeEncoding];
    }
    char *returnType = method_copyReturnType(method);
    if (returnType) {
        _returnTypeEncoding = [NSString stringWithUTF8String:returnType];
        free(returnType);
    }
    unsigned int argumentCount = method_getNumberOfArguments(method);
    if (argumentCount > 0) {
        NSMutableArray *argumentTypes = [NSMutableArray new];
        for (unsigned int i = 0; i < argumentCount; i++) {
            char *argumentType = method_copyArgumentType(method, i);
            NSString *type = argumentType ? [NSString stringWithUTF8String:argumentType] : nil;
            [argumentTypes addObject:type ? type : @""];
            if (argumentType) free(argumentType);
        }
        _argumentTypeEncodings = argumentTypes;
    }
    return self;
}

@end

@implementation WXMFMDBClassPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property {
    if (!property) return nil;
    self = [self init];
    _property = property;
    const char *name = property_getName(property);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    
    WXMFMDBEncodingType type = 0;
    unsigned int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
    for (unsigned int i = 0; i < attrCount; i++) {
        switch (attrs[i].name[0]) {
            case 'T': { // Type encoding
                if (attrs[i].value) {
                    _typeEncoding = [NSString stringWithUTF8String:attrs[i].value];
                    type = WXMFMDBEncodingGetType(attrs[i].value);
                    if ((type & WXMFMDBEncodingTypeMask) == WXMFMDBEncodingTypeObject) {
                        size_t len = strlen(attrs[i].value);
                        if (len > 3) {
                            char name[len - 2];
                            name[len - 3] = '\0';
                            memcpy(name, attrs[i].value + 2, len - 3);
                            _cls = objc_getClass(name);
                        }
                    }
                }
            } break;
            case 'V': { // Instance variable
                if (attrs[i].value) {
                    _ivarName = [NSString stringWithUTF8String:attrs[i].value];
                }
            } break;
            case 'R': {
                type |= WXMFMDBEncodingTypePropertyReadonly;
            } break;
            case 'C': {
                type |= WXMFMDBEncodingTypePropertyCopy;
            } break;
            case '&': {
                type |= WXMFMDBEncodingTypePropertyRetain;
            } break;
            case 'N': {
                type |= WXMFMDBEncodingTypePropertyNonatomic;
            } break;
            case 'D': {
                type |= WXMFMDBEncodingTypePropertyDynamic;
            } break;
            case 'W': {
                type |= WXMFMDBEncodingTypePropertyWeak;
            } break;
            case 'G': {
                type |= WXMFMDBEncodingTypePropertyCustomGetter;
                if (attrs[i].value) {
                    _getter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }
            } break;
            case 'S': {
                type |= WXMFMDBEncodingTypePropertyCustomSetter;
                if (attrs[i].value) {
                    _setter = NSSelectorFromString([NSString stringWithUTF8String:attrs[i].value]);
                }
            } break;
            default: break;
        }
    }
    if (attrs) {
        free(attrs);
        attrs = NULL;
    }
    
    _type = type;
    if (_name.length) {
        if (!_getter) {
            _getter = NSSelectorFromString(_name);
        }
        if (!_setter) {
            _setter = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", [_name substringToIndex:1].uppercaseString, [_name substringFromIndex:1]]);
        }
    }
    return self;
}

@end

@implementation WXMFMDBClassInfo {
    BOOL _needUpdate;
}

- (instancetype)initWithClass:(Class)cls {
    if (!cls) return nil;
    self = [super init];
    _cls = cls;
    _superCls = class_getSuperclass(cls);
    _isMeta = class_isMetaClass(cls);
    if (!_isMeta) {
        _metaCls = objc_getMetaClass(class_getName(cls));
    }
    _name = NSStringFromClass(cls);
    [self _update];

    _superClassInfo = [self.class classInfoWithClass:_superCls];
    return self;
}

- (void)_update {
    _ivarInfos = nil;
    _methodInfos = nil;
    _propertyInfos = nil;
    
    Class cls = self.cls;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
    if (methods) {
        NSMutableDictionary *methodInfos = [NSMutableDictionary new];
        _methodInfos = methodInfos;
        for (unsigned int i = 0; i < methodCount; i++) {
            WXMFMDBClassMethodInfo *info = [[WXMFMDBClassMethodInfo alloc] initWithMethod:methods[i]];
            if (info.name) methodInfos[info.name] = info;
        }
        free(methods);
    }
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
    if (properties) {
        NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
        _propertyInfos = propertyInfos;
        for (unsigned int i = 0; i < propertyCount; i++) {
            WXMFMDBClassPropertyInfo *info = [[WXMFMDBClassPropertyInfo alloc] initWithProperty:properties[i]];
            if (info.name) propertyInfos[info.name] = info;
        }
        free(properties);
    }
    
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarCount);
    if (ivars) {
        NSMutableDictionary *ivarInfos = [NSMutableDictionary new];
        _ivarInfos = ivarInfos;
        for (unsigned int i = 0; i < ivarCount; i++) {
            WXMFMDBClassIvarInfo *info = [[WXMFMDBClassIvarInfo alloc] initWithIvar:ivars[i]];
            if (info.name) ivarInfos[info.name] = info;
        }
        free(ivars);
    }
    
    if (!_ivarInfos) _ivarInfos = @{};
    if (!_methodInfos) _methodInfos = @{};
    if (!_propertyInfos) _propertyInfos = @{};
    
    _needUpdate = NO;
}

- (void)setNeedUpdate {
    _needUpdate = YES;
}

- (BOOL)needUpdate {
    return _needUpdate;
}

+ (instancetype)classInfoWithClass:(Class)cls {
    if (!cls) return nil;
    static CFMutableDictionaryRef classCache;
    static CFMutableDictionaryRef metaCache;
    static dispatch_once_t onceToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&onceToken, ^{
        classCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        metaCache = CFDictionaryCreateMutable(CFAllocatorGetDefault(), 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    WXMFMDBClassInfo *info = CFDictionaryGetValue(class_isMetaClass(cls) ? metaCache : classCache, (__bridge const void *)(cls));
    if (info && info->_needUpdate) {
        [info _update];
    }
    dispatch_semaphore_signal(lock);
    if (!info) {
        info = [[WXMFMDBClassInfo alloc] initWithClass:cls];
        if (info) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(info.isMeta ? metaCache : classCache, (__bridge const void *)(cls), (__bridge const void *)(info));
            dispatch_semaphore_signal(lock);
        }
    }
    return info;
}

+ (instancetype)classInfoWithClassName:(NSString *)className {
    Class cls = NSClassFromString(className);
    return [self classInfoWithClass:cls];
}

@end
