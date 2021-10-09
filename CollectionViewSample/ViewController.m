//
//  ViewController.m
//  CollectionViewSample
//
//  Created by Prakash Maharjan on 2/22/17.
//  Copyright © 2017 Prakash Maharjan. All rights reserved.
//

#import "ViewController.h"
#import "ColCell.h"
#import <Photos/Photos.h>
@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionVC;
@property(nonatomic , strong) PHFetchResult *assetsFetchResults;
@property(nonatomic , strong) PHCachingImageManager *imageManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    _assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    
    _imageManager = [[PHCachingImageManager alloc] init];

}

-(void)getAllGalleryImages{
    __block PHAssetCollection *collection;
    
    // Find the album
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", @"YOUR_CUSTOM_ALBUM_NAME"];
    collection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                          subtype:PHAssetCollectionSubtypeAny
                                                          options:fetchOptions].firstObject;
    
    PHFetchResult *collectionResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    
    [collectionResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {

        //add assets to an array for later use in the uicollectionviewcell
        NSLog(@"asset::%@",asset);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     return [_assetsFetchResults count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ColCell *cell = [self.collectionVC dequeueReusableCellWithReuseIdentifier:@"ColCell" forIndexPath:indexPath];
    
    PHAsset *asset = _assetsFetchResults[indexPath.item];
    
    [_imageManager requestImageForAsset:asset targetSize:cell.colImgVC.frame.size contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info)
     {

         cell.colImgVC.image = result;
     }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = _assetsFetchResults[indexPath.item];
    
    [_imageManager requestImageForAsset:asset targetSize:CGSizeMake(111, 111) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage *result, NSDictionary *info)
     {
         // result is the actual image object.
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
