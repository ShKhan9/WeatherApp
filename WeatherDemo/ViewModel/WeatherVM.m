//
//  WeatherViewModel.m
//  WeatherDemo
//
//  Created by MacBook Pro on 9/3/21.
//

#import "WeatherVM.h"
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
const NSString* apiKey = @"f5cb0b965ea1564c50c6f1b74534d823";
const NSString* domain = @"https://api.openweathermap.org/data/2.5/weather";
@implementation WeatherVM

-(void) getWeatherDataForCityName:(NSString*)cityName completionAction:(CompletionBlock)completion{
    // Show progress while the request is being made
    [SVProgressHUD show];
    // Compose needed url for the request
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString* urlStr = [NSString stringWithFormat:@"%@?q=%@&appid=%@",domain,cityName,apiKey];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    // Start the request asyncrounsly
    [manager GET:urlStr parameters:NULL headers:NULL progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable results) {
        // parse response to get needed data
        id weather = [[results objectForKey:@"weather"] objectAtIndex:0];
        NSNumber* date  = [results objectForKey:@"dt"];
        NSNumber* cityId  = [results objectForKey:@"id"];
        NSString* name  = [results objectForKey:@"name"];
        NSString* description  = [weather objectForKey:@"description"];
        NSString* icon  = [weather objectForKey:@"icon"];
        NSNumber* speed = [[results objectForKey:@"wind"] objectForKey:@"speed"];
        NSNumber* temp = [[results objectForKey:@"main"] objectForKey:@"temp"];
        NSNumber* humidity = [[results objectForKey:@"main"] objectForKey:@"humidity"];
        NSDictionary*dic = @{@"description":description,@"icon":icon,@"iconId":icon,@"name":name,
                             @"speed":speed.stringValue,@"temp":temp.stringValue,@"humidity":humidity.stringValue,@"date":date.stringValue,@"cityId":cityId.stringValue};
        
        // Return info to caller
        completion(dic);
        // Remove the progress after the request is done
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // Return nil with error case
        completion(NULL);
        // Remove the progress after the request is done
        [SVProgressHUD dismiss];
    }];
    
}

-(void) getWeatherDataForZipCode:(NSString*)zipCode completionAction:(CompletionBlock)completion{
    // Show progress while the request is being made
    [SVProgressHUD show];
    // Compose needed url for the request
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString* urlStr = [NSString stringWithFormat:@"%@?zip=%@&appid=%@",domain,zipCode,apiKey];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    // Start the request asyncrounsly
    [manager GET:urlStr parameters:NULL headers:NULL progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable results) {
      
        // parse response to get needed data
        id weather = [[results objectForKey:@"weather"] objectAtIndex:0];
        NSNumber* date  = [results objectForKey:@"dt"];
        NSNumber* cityId  = [results objectForKey:@"id"];
        NSString* name  = [results objectForKey:@"name"];
        NSString* description  = [weather objectForKey:@"description"];
        NSString* icon  = [weather objectForKey:@"icon"];
        NSNumber* speed = [[results objectForKey:@"wind"] objectForKey:@"speed"];
        NSNumber* temp = [[results objectForKey:@"main"] objectForKey:@"temp"];
        NSNumber* humidity = [[results objectForKey:@"main"] objectForKey:@"humidity"];
        NSDictionary*dic = @{@"description":description,@"icon":icon,@"iconId":icon,@"name":name,
                             @"speed":speed.stringValue,@"temp":temp.stringValue,@"humidity":humidity.stringValue,@"date":date.stringValue,@"cityId":cityId.stringValue};
        
        // Return info to caller
        completion(dic);
        // Remove the progress after the request is done
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // Return nil with error case
        completion(NULL);
        // Remove the progress after the request is done
        [SVProgressHUD dismiss];
    }];
    
}

-(void) getWeatherDataForLat:(double)lat andLon:(double)lon completionAction:(CompletionBlock)completion{
    // Show progress while the request is being made
    [SVProgressHUD show];
    // Compose needed url for the request
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString* urlStr = [NSString stringWithFormat:@"%@?lat=%f&lon=%f&appid=%@",domain,lat,lon,apiKey];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    // Start the request asyncrounsly
    [manager GET:urlStr parameters:NULL headers:NULL progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable results) {
      
        // parse response to get needed data
        id weather = [[results objectForKey:@"weather"] objectAtIndex:0];
        NSNumber* date  = [results objectForKey:@"dt"];
        NSNumber* cityId  = [results objectForKey:@"id"];
        NSString* name  = [results objectForKey:@"name"];
        NSString* description  = [weather objectForKey:@"description"];
        NSString* icon  = [weather objectForKey:@"icon"];
        NSNumber* speed = [[results objectForKey:@"wind"] objectForKey:@"speed"];
        NSNumber* temp = [[results objectForKey:@"main"] objectForKey:@"temp"];
        NSNumber* humidity = [[results objectForKey:@"main"] objectForKey:@"humidity"];
        NSDictionary*dic = @{@"description":description,@"icon":icon,@"iconId":icon,@"name":name,
                             @"speed":speed.stringValue,@"temp":temp.stringValue,@"humidity":humidity.stringValue,@"date":date.stringValue,@"cityId":cityId.stringValue};
        
        // Return info to caller
        completion(dic);
        // Remove the progress after the request is done
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // Return nil with error case
        completion(NULL);
        // Remove the progress after the request is done
        [SVProgressHUD dismiss];
    }];
    
}

@end
