//
//  BoatControllerProtocol.h
//  Pods
//
//  Created by bin on 3/11/14.
//
//

#ifndef Pods_BoatControllerProtocol_h
#define Pods_BoatControllerProtocol_h

@protocol BoatControllerProtocol

- (NSString *) layoutName;
- (void) renderView:(NSDictionary *)params;
- (NSDictionary *) layoutExtraParams;

@end

#endif
