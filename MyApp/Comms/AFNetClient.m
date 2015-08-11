//
//  AFNetClient.m
//  MyApp
//
//  Created by Faustino L on 4/24/14.
//

#import "AFNetClient.h"

#import "Config.h"
#import "AppUtils.h"

@implementation AFNetClient

+ (AFNetClient *)sharedAFNetClient
{
    static AFNetClient *_sharedAFNetClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAFNetClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_SERVER_URL]];
    });
    
    return _sharedAFNetClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (void)setRequestSerializer:(NSUInteger)requestSerializerType ResponseSerializer:(NSUInteger)responseSerializerType
{
    if (requestSerializerType == AFNetClientRequestSerializerTypeJSON)
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    else if (requestSerializerType == AFNetClientRequestSerializerTypePLIST)
        self.requestSerializer = [AFPropertyListRequestSerializer serializer];
    
    if (responseSerializerType == AFNetClientResponseSerializerTypeJSON)
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    else if (responseSerializerType == AFNetClientResponseSerializerTypeXML)
        self.responseSerializer = [AFXMLParserResponseSerializer serializer];
    else if (responseSerializerType == AFNetClientResponseSerializerTypePLIST)
        self.responseSerializer = [AFPropertyListResponseSerializer serializer];
}

- (void)getResponseFromServerWithClientType:(BOOL)type Params:(NSDictionary *)params
{
    if (type) { // POST
        [self POST:@"weather.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([self.delegate respondsToSelector:@selector(afnetClient:didSuccessWithResponse:)]) {
                [self.delegate afnetClient:self didSuccessWithResponse:responseObject];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if ([self.delegate respondsToSelector:@selector(afnetClient:didFailWithError:)]) {
                [self.delegate afnetClient:self didFailWithError:error];
            }
        }];
    } else { // GET
        [self GET:@"weather.php" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([self.delegate respondsToSelector:@selector(afnetClient:didSuccessWithResponse:)]) {
                [self.delegate afnetClient:self didSuccessWithResponse:responseObject];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if ([self.delegate respondsToSelector:@selector(afnetClient:didFailWithError:)]) {
                [self.delegate afnetClient:self didFailWithError:error];
            }
        }];
    }
}
@end