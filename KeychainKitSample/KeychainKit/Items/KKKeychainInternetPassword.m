//
//  KKKeychainInternetPassword.m
//  KeychainKitSample
//
//  Created by david on 11/01/15.
//

#import <Security/Security.h>
#import "KKKeychainInternetPassword.h"
#import "KKKeychainItem+SuclassesInterface.h"
#import "KKKeychainPassword+SuclassesInterface.h"
#import "KKKeychainItem+KeychainKitInterface.h"
#import "NSMutableDictionary+KeychainKit.h"

@interface KKKeychainInternetPassword ()

@property (nonatomic, copy, readwrite) NSString *securityDomain;
@property (nonatomic, copy, readwrite) NSString *server;
@property (nonatomic, assign, readwrite) KKKeychainProtocol protocol;
@property (nonatomic, assign, readwrite) KKKeychainAuthenticationType authenticationType;
@property (nonatomic, readwrite) NSNumber *port;
@property (nonatomic, copy, readwrite) NSString *path;

@end

@implementation KKKeychainInternetPassword

#pragma mark - Object Life Cycle

- (instancetype)initWithData:(NSData *)data label:(NSString *)label accessGroup:(NSString *)accessGroup
                creationDate:(NSDate *)creationDate modificationDate:(NSDate *)modificationDate
             itemDescription:(NSString *)itemDescription comment:(NSString *)comment
                     creator:(NSNumber *)creator type:(NSNumber *)type isInvisible:(BOOL)isInvisible
                  isNegative:(BOOL)isNegative account:(NSString *)account
              securityDomain:(NSString *)securityDomain server:(NSString *)server
                    protocol:(KKKeychainProtocol)protocol
          authenticationType:(KKKeychainAuthenticationType)authenticationType port:(NSNumber *)port
                        path:(NSString *)path accessibility:(KKKeychainItemAccessibility)accessibility {
    self = [super initWithData:data label:label accessGroup:accessGroup creationDate:creationDate
              modificationDate:modificationDate itemDescription:itemDescription comment:comment
                       creator:creator type:type isInvisible:isInvisible isNegative:isNegative
                       account:accessGroup accessibility:accessibility];
    
    if (self) {
        self.securityDomain = securityDomain;
        self.server = server;
        self.protocol = protocol;
        self.authenticationType = authenticationType;
        self.port = port;
        self.path = path;
    }
    
    return self;
}

#pragma mark - Keychain mapping

/*!
 *  @return CFTypeRef associated to Intenert Protocol chosen by Item's creator.
 */
- (CFTypeRef)protocolFromInternetPassword {
    switch (self.protocol) {
        case KKKeychainProtocolFTP:
            return kSecAttrProtocolFTP;
        case KKKeychainProtocolFTPS:
            return kSecAttrProtocolFTPS;
        case KKKeychainProtocolFTPProxy:
            return kSecAttrProtocolFTPProxy;
        case KKKeychainProtocolFTPAccount:
            return kSecAttrProtocolFTPAccount;
        case KKKeychainProtocolHTTP:
            return kSecAttrProtocolHTTP;
        case KKKeychainProtocolHTTPS:
            return kSecAttrProtocolHTTPS;
        case KKKeychainProtocolHTTPProxy:
            return kSecAttrProtocolHTTPProxy;
        case KKKeychainProtocolHTTPSProxy:
            return kSecAttrProtocolHTTPSProxy;
        case KKKeychainProtocolIRC:
            return kSecAttrProtocolIRC;
        case KKKeychainProtocolIRCS:
            return kSecAttrProtocolIRCS;
        case KKKeychainProtocolNNTP:
            return kSecAttrProtocolNNTP;
        case KKKeychainProtocolNNTPS:
            return kSecAttrProtocolNNTPS;
        case KKKeychainProtocolPOP3:
            return kSecAttrProtocolPOP3;
        case KKKeychainProtocolPOP3S:
            return kSecAttrProtocolPOP3S;
        case KKKeychainProtocolSMTP:
            return kSecAttrProtocolSMTP;
        case KKKeychainProtocolSOCKS:
            return kSecAttrProtocolSOCKS;
        case KKKeychainProtocolIMAP:
            return kSecAttrProtocolIMAP;
        case KKKeychainProtocolIMAPS:
            return kSecAttrProtocolIMAPS;
        case KKKeychainProtocolLDAP:
            return kSecAttrProtocolLDAP;
        case KKKeychainProtocolLDAPS:
            return kSecAttrProtocolLDAPS;
        case KKKeychainProtocolAppleTalk:
            return kSecAttrProtocolAppleTalk;
        case KKKeychainProtocolAFP:
            return kSecAttrProtocolAFP;
        case KKKeychainProtocolTelnet:
            return kSecAttrProtocolTelnet;
        case KKKeychainProtocolTelnetS:
            return kSecAttrProtocolTelnetS;
        case KKKeychainProtocolSSH:
            return kSecAttrProtocolSSH;
        case KKKeychainProtocolSMB:
            return kSecAttrProtocolSMB;
        case KKKeychainProtocolRTSP:
            return kSecAttrProtocolRTSP;
        case KKKeychainProtocolRTSPProxy:
            return kSecAttrProtocolRTSPProxy;
        case KKKeychainProtocolDAAP:
            return kSecAttrProtocolDAAP;
        case KKKeychainProtocolEPPC:
            return kSecAttrProtocolEPPC;
        case KKKeychainProtocolIPP:
            return kSecAttrProtocolIPP;
    }
}

/*!
 *  @return CFTypeRef associated to Authentication type chosen by Item's creator.
 */
- (CFTypeRef)authenticationTypeFromInternetPassword {
    switch (self.authenticationType) {
        case KKKeychainAuthenticationTypeNTLM:
            return kSecAttrAuthenticationTypeNTLM;
        case KKKeychainAuthenticationTypeMSN:
            return kSecAttrAuthenticationTypeMSN;
        case KKKeychainAuthenticationTypeDPA:
            return kSecAttrAuthenticationTypeDPA;
        case KKKeychainAuthenticationTypeRPA:
            return kSecAttrAuthenticationTypeRPA;
        case KKKeychainAuthenticationTypeHTMLForm:
            return kSecAttrAuthenticationTypeHTMLForm;
        case KKKeychainAuthenticationTypeHTTPBasic:
            return kSecAttrAuthenticationTypeHTTPBasic;
        case KKKeychainAuthenticationTypeHTTPDigest:
            return kSecAttrAuthenticationTypeHTTPDigest;
        case KKKeychainAuthenticationTypeDefault:
            return kSecAttrAuthenticationTypeDefault;
    }
}

#pragma mark - Item Conversion

- (NSDictionary *)keychainAttributesWithError:(NSError **)error {
    NSDictionary *attributes = [super keychainAttributesWithError:error];
    if (attributes) {
        NSMutableDictionary *mutableAttributes = [[NSMutableDictionary alloc] initWithDictionary:attributes];
        [mutableAttributes setObjectSafely:(__bridge id)kSecClassInternetPassword
                                    forKey:(__bridge id)kSecClass];
        [mutableAttributes setObjectSafely:self.securityDomain
                                    forKey:(__bridge id)kSecAttrSecurityDomain];
        [mutableAttributes setObjectSafely:self.server
                                    forKey:(__bridge id)kSecAttrServer];
        [mutableAttributes setObjectSafely:[self protocolFromInternetPassword]
                                    forKey:(__bridge id)kSecAttrProtocol];
        [mutableAttributes setObjectSafely:[self authenticationTypeFromInternetPassword]
                                    forKey:(__bridge id)kSecAttrAuthenticationType];
        [mutableAttributes setObjectSafely:self.port
                                    forKey:(__bridge id)kSecAttrPort];
        [mutableAttributes setObjectSafely:self.path forKey:(__bridge id)kSecAttrPath];
    }
    return attributes;
}

@end
