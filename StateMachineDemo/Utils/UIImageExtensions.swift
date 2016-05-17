import UIKit

public extension UIImage
{
    public class func imageOfSize(size:CGSize, withColor color:UIColor = UIColor.redColor()) -> UIImage
    {
        return self.renderContent(size)
        {
            color.setFill()
            UIRectFill( CGRect( origin: CGPointZero, size: size ) )
        }
    }
    
    public class func imageOfSize(size:CGSize, withColor color:UIColor, mergedWithImages images:[(UIImage, CGRect)]) -> UIImage
    {
        return self.renderContent(size)
        {
            color.setFill()
            UIRectFill( CGRect( origin: CGPointZero, size: size ) )
            
            for (image, rect) in images
            {
                image.drawInRect(rect)
            }
        }
    }
    
    public class func imageOfSize(size:CGSize, withColor color:UIColor, mergedWithImages images:[(UIImage, CGPoint)]) -> UIImage
    {
        return self.renderContent(size)
        {
            color.setFill()
            UIRectFill( CGRect( origin: CGPointZero, size: size ) )
            
            for (image, point) in images
            {
                let rect = CGRect(origin: point, size: image.size)
                image.drawInRect(rect)
            }
        }
    }
    
    public class func imageOfSize(size:CGSize, withColor color:UIColor, mergedWithImages images:[UIImage]) -> UIImage
    {
        return self.renderContent(size)
        {
            color.setFill()
            UIRectFill( CGRect( origin: CGPointZero, size: size ) )
            
            for image in images
            {
                let rect = CGRect(origin: CGPointZero, size: image.size)
                image.drawInRect(rect)
            }
        }
    }
    
    private class func renderContent(size:CGSize, completion:() -> Void) -> UIImage
    {
        UIGraphicsBeginImageContext(size)
        
        completion()
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return finalImage
    }
    
    
    public func imageCroppedWithRect( rect:CGRect ) -> UIImage
    {
        let imageRef = CGImageCreateWithImageInRect( self.CGImage, rect )!
        return UIImage( CGImage: imageRef, scale: self.scale, orientation: self.imageOrientation )
    }
}