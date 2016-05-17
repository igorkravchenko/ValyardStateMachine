import UIKit

public extension UIView
{
    public var snapshotImage:UIImage
    {
        UIGraphicsBeginImageContext(self.bounds.size);
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenshot
    }
}

