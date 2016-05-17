import UIKit
import ValyardStateMachine

public class PlanesEffect : UIView
{
    private enum PlanesState
    {
        case Invisible,
        Show,
        Visible,
        Hide,
        Any
    }
    
    private let stateMachine:StateMachine<PlanesState, Int, PlanesState, Int> = StateMachine(.Any)
    private let effect = UIView()
    
    private var _obj:UIView
    private var _planes = 0
    
    public init(obj:UIView, planes:Int = 10)
    {
        _obj = obj
        _obj.hidden = true
        
        _planes = planes
        
        super.init( frame: CGRectZero )
        
        addSubview( _obj )
        addSubview( effect )
        
        stateMachine.add( fromState: .Invisible, toState: .Visible, via: .Show )
        stateMachine.add( fromState: .Visible, toState: .Invisible, via: .Hide )
        
        stateMachine.addTransitionListener( fromState: .Any, toState: .Invisible, funcId: .Invisible, function: stateInvisible )
        stateMachine.addTransitionListener( fromState: .Any, toState: .Hide, funcId: .Hide, function: stateHide )
        stateMachine.addTransitionListener( fromState: .Any, toState: .Visible, funcId: .Visible, function: stateVisible )
        stateMachine.addTransitionListener( fromState: .Any, toState: .Show, funcId: .Show, function: stateShow )
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show()
    {
        stateMachine.setState(.Visible)
    }
    
    public func hide()
    {
        stateMachine.setState(.Invisible)
    }
    
    private func stateInvisible()
    {
        _obj.hidden = true
    }
    
    private func stateHide()
    {
        _obj.hidden = true
        divideToPlanes()
        
        let planes = effect.subviews
        
        let timeScale = 1.0
        
        for i in 0 ..< _planes
        {
            let mul = (1 - 2 * (i % 2))
            let plane = planes[i]
            var frame = plane.frame
            let w = CGRectGetWidth(frame) * 0.5
            let h = CGRectGetHeight(frame)
            
            frame.origin.x = w
            frame.origin.y = i * h
            plane.frame = frame
            plane.alpha = 1
            plane.transform = CGAffineTransformMakeScale(1, 1)
            plane.layer.transform = CATransform3DIdentity
            
            let planeDelay = (  0.05 +  NSTimeInterval(mul) * 0.05  +  NSTimeInterval(_planes - i) * 0.01 + NSTimeInterval.random() * 0.2 ) * timeScale
            
            UIView.animateWithDuration(1.0, delay: planeDelay, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
                
                var f = plane.frame
                f.origin.x =  w + mul * 200.0
                f.origin.y = i * h - h * 0.5
                plane.frame = f
                plane.alpha = 0
                plane.transform = CGAffineTransformMakeScale(1, 2);
                
                plane.layer.transform = CATransform3DMakeRotation(degreesToRadians(CGFloat(mul * 80)), 1, 0, 0)

                
                },
                completion:
                {
                    done in
                    if done && i == self._planes - 1
                    {
                        
                        self.clean()
                        
                    }
            })
        }
    }
    
    private func stateVisible()
    {
        _obj.hidden = false
    }
    
    private func stateShow()
    {
        divideToPlanes()
        
        let planes = effect.subviews
        
        let timeScale = 1.0
        
        for i in 0 ..< _planes
        {
            let mul = (1 - 2 * (i % 2))
            let plane = planes[i]
            var frame = plane.frame
            let w = CGRectGetWidth(frame) * 0.5
            let h = CGRectGetHeight(frame)
            
            var f = plane.frame
            f.origin.x =  w + mul * 200.0
            f.origin.y = i * h - h * 0.5
            plane.frame = f
            plane.alpha = 0
            plane.transform = CGAffineTransformMakeScale(1, 2);
            
            plane.layer.transform = CATransform3DMakeRotation(degreesToRadians(CGFloat(mul * 80)), 1, 0, 0)
            let planeDelay = (  0.05 +  NSTimeInterval(mul) * 0.05  +  NSTimeInterval(_planes - i) * 0.01 + NSTimeInterval.random() * 0.2 ) * timeScale
            
            UIView.animateWithDuration(1.0, delay: planeDelay, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: [], animations: {
                
                frame.origin.x = w
                frame.origin.y = i * h
                plane.frame = frame
                plane.alpha = 1
                plane.transform = CGAffineTransformMakeScale(1, 1)
                plane.layer.transform = CATransform3DIdentity
                
                },
                completion:
                {
                    done in
                    if done && i == self._planes - 1
                    {
                        
                        self.clean()
                        
                    }
                })
        }
    }
    
    private func divideToPlanes()
    {
        let w = CGRectGetWidth( _obj.frame )
        let h = CGRectGetHeight( _obj.frame )
        let s = Int(ceil ( h / CGFloat(_planes) ) )
        let hidden = _obj.hidden
        _obj.hidden = false
        let master = _obj.snapshotImage
        _obj.hidden = hidden
        
        for i in 0 ..< _planes
        {
            let bmpd = master.imageCroppedWithRect( CGRectMake(0, CGFloat(i * s), w, CGFloat(s)) )
            let bmp = UIImageView(image: bmpd)
            let plane = UIView(frame:bmp.bounds)
            plane.addSubview(bmp)
            var frame = bmp.frame
            frame.origin.x = -w * 0.5
            bmp.frame = frame
            effect.addSubview(plane)
        }
    }
    
    private func clean()
    {
        var views = effect.subviews
        while !views.isEmpty
        {
            views[views.count - 1].removeFromSuperview()
            views.removeLast()
        }
        stateMachine.release()
    }
}