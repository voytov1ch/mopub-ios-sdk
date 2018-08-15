//
//  MPNativeAdRendererImageHandler.m
//  Copyright (c) 2015 MoPub. All rights reserved.
//

#import "MPNativeAdRendererImageHandler.h"
#import "MPLogging.h"
#import "MPNativeCache.h"
#import "MPImageDownloadQueue.h"

@interface MPNativeAdRendererImageHandler()

@property (nonatomic) MPImageDownloadQueue *imageDownloadQueue;

@end

@implementation MPNativeAdRendererImageHandler

- (instancetype)init
{
    if (self = [super init]) {
        _imageDownloadQueue = [[MPImageDownloadQueue alloc] init];
    }
    return self;
}

- (void)loadImageForURL:(NSURL *)imageURL intoImageView:(UIImageView *)imageView
{
    imageView.image = nil;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *cachedImageData = [[MPNativeCache sharedCache] retrieveDataForKey:imageURL.absoluteString];
        UIImage *image = [UIImage imageWithData:cachedImageData];

        if (image) {
            [self safeMainQueueSetImage:image intoImageView:imageView];
        } else if (imageURL) {
            MPLogDebug(@"Cache miss on %@. Re-downloading...", imageURL);

            __weak __typeof__(self) weakSelf = self;
            [self.imageDownloadQueue addDownloadImageURLs:@[imageURL]
                                          completionBlock:^(NSArray *errors) {
                                              __strong __typeof__(self) strongSelf = weakSelf;
                                              if (strongSelf) {
                                                  if (errors.count == 0) {
                                                      UIImage *image = [UIImage imageWithData:[[MPNativeCache sharedCache] retrieveDataForKey:imageURL.absoluteString]];

                                                      [strongSelf safeMainQueueSetImage:image intoImageView:imageView];
                                                  } else {
                                                      MPLogDebug(@"Failed to download %@ on cache miss. Giving up for now.", imageURL);
                                                  }
                                              } else {
                                                  MPLogInfo(@"MPNativeAd deallocated before loadImageForURL:intoImageView: download completion block was called");
                                              }
                                          }];
        }
    });
}

- (void)safeMainQueueSetImage:(UIImage *)image intoImageView:(UIImageView *)imageView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (image) {
            imageView.image = image;
        }
    });
}

@end
