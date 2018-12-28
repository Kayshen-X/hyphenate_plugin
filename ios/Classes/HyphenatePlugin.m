#import "HyphenatePlugin.h"
#import <hyphenate_plugin/hyphenate_plugin-Swift.h>

@implementation HyphenatePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHyphenatePlugin registerWithRegistrar:registrar];
}
@end
