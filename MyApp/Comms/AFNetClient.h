//
//  AFNetClient.h
//  MyApp
//
//  Created by Faustino L on 4/24/14.
//

#import "AFHTTPSessionManager.h"

/**
 *  A constant describing the AFNetworking Request and Response Serializer type. 
    This sets the AFNetworking Request and Response Serializer.
 */
typedef NS_ENUM(NSUInteger, AFNetClientRequestSerializerType) {
    AFNetClientRequestSerializerTypeJSON,
    AFNetClientRequestSerializerTypePLIST
};
typedef NS_ENUM(NSUInteger, AFNetClientResponseSerializerType) {
    AFNetClientResponseSerializerTypeJSON,
    AFNetClientResponseSerializerTypeXML,
    AFNetClientResponseSerializerTypePLIST
};

/**
 *  A constant describing the AFNetworking action type. This sets the AFNetworking action.
 */
typedef NS_ENUM(NSUInteger, AFNetClientActionType) {
    AFNetClientActionTypeTest
};

@protocol AFNetClientDelegate;

@interface AFNetClient : AFHTTPSessionManager
@property (nonatomic, weak) id<AFNetClientDelegate>delegate;

+ (AFNetClient *)sharedAFNetClient;
- (instancetype)initWithBaseURL:(NSURL *)url;
- (void)setRequestSerializer:(NSUInteger)requestSerializerType ResponseSerializer:(NSUInteger)responseSerializerType;

- (void)getResponseFromServerWithClientType:(BOOL)type Params:(NSDictionary *)params;
@end


@protocol AFNetClientDelegate <NSObject>
@optional
- (void)afnetClient:(AFNetClient *)client didSuccessWithResponse:(id)response;
- (void)afnetClient:(AFNetClient *)client didFailWithError:(NSError *)error;
@end
