//
//  XCTestRemoteController.swift
//  XCTestWD
//
//  Created by icbc on 2018/8/18.
//  Copyright © 2018 XCTestWD. All rights reserved.
//

import Foundation
import Swifter
import SwiftyJSON

internal class XCTestWDRemoteController: Controller {
    
    //MARK: Controller - Protocol
    static func routes() -> [(RequestRoute, RoutingCall)] {
        return [(RequestRoute("/wd/hub/screenshotjpg", "post"), getScreenshotJpg),
                (RequestRoute("/wd/hub/session/:sessionId/screenshotjpg", "post"), getScreenshotJpg),
        ]
    }
    
    static func shouldRegisterAutomatically() -> Bool {
        return false
    }
    
    internal static func getScaledScreenshot( imagex:CGFloat,  interpolationQuality:CGInterpolationQuality) ->UIImage
    {
        // get screenshot png image
        let imagey:CGFloat;
        
        var screenshotData :NSData! ;
        
        
        
        let xcScreen:AnyClass? = NSClassFromString("XCUIScreen")
        if xcScreen != nil {
            screenshotData = xcScreen?.value(forKeyPath: "mainScreen.screenshot.PNGRepresentation") as? NSData
            
        } else {
            screenshotData = (XCAXClient_iOS.sharedClient() as! XCAXClient_iOS).screenshotData() as! NSData
            
        }
        // store png image to UIImage
        let image  :UIImage  = UIImage(data: screenshotData as Data)!;
        var scaledImage:UIImage = UIImage() ;
        
        var bounds:CGRect;
         
         if (imagex != 0.0 ) {
         //if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown || orientation == UIInterfaceOrientationUnknown )
         if(image.size.height>image.size.width)
         {
         imagey = image.size.height * imagex / image.size.width ;
            bounds = CGRect.init(x:0.0, y:0.0, width:imagex ,  height:imagey );
         //  NSLog(@"height>width: imagex = %f, imagey=%f, quality=%d",imagex, imagey,interpolationQuality  );
         }else{
         imagey = image.size.width * imagex / image.size.height ;
            bounds = CGRect(x:0, y:0, width:imagey ,  height:imagex );
         
         //  NSLog(@"height<width  imagex = %f, imagey=%f, quality=%d "    ,imagex, imagey, interpolationQuality);
         }
         
         UIGraphicsBeginImageContext( bounds.size );
         
            let   context: CGContext = UIGraphicsGetCurrentContext()!;
        context.interpolationQuality = interpolationQuality;
         
         image.draw(in:  bounds);
         
            scaledImage = UIGraphicsGetImageFromCurrentImageContext()!;
         UIGraphicsEndImageContext();
         
         
         
         }
        return scaledImage;
    }
    
    internal static func getScreenshotJpg(request: Swifter.HttpRequest) -> Swifter.HttpResponse {
        let imagex :Float = request.jsonBody["imagex"].floatValue ;
        let compressrate :Float =  (request.jsonBody["compressRate"].floatValue);
        let quality:NSString =   request.jsonBody["quality"].stringValue as NSString;
        
        var  interpolation : CGInterpolationQuality = CGInterpolationQuality.default ;
        
        if( quality.isEqual(to: "HIGH")){
            interpolation = CGInterpolationQuality.high;
        }else if(quality.isEqual("LOW" )){
            interpolation = CGInterpolationQuality.low;
        }else if(  quality.isEqual("Medium")){
            interpolation = CGInterpolationQuality.medium;
        }else if( quality.isEqual("NONE")){
            interpolation = CGInterpolationQuality.none;
        }
        
        
        let scaledImage:UIImage =  getScaledScreenshot( imagex: CGFloat(imagex),  interpolationQuality: interpolation);
        
        
        let  jpgData:Data = UIImageJPEGRepresentation(scaledImage, ((CGFloat)(compressrate)))!;
        
        let base64String = ((jpgData.base64EncodedString()))
        return XCTestWDResponse.response(session: request.session, value: JSON(base64String))
       
    }
}
