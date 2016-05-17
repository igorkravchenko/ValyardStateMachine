
import CoreGraphics.CGGeometry

extension CGFloat
{
    static let PI = CGFloat( M_PI )

    public static func random() -> CGFloat
    {
        return CGFloat( arc4random() % UInt32.max ) / CGFloat( UInt32.max )
    }
 
    public func isValid() -> Bool
    {
        return isfinite( self ) && !isnan( self )
    }
}

public func * ( a : Int, s : CGFloat ) -> CGFloat
{
    return CGFloat( a ) * s
}

public func * ( lhs : CGFloat, rhs : Int ) -> CGFloat
{
    return lhs * CGFloat( rhs )
}

extension CGPoint
{
    public init( _ x : Int, _ y : Int)
    {
        self.init(x : x, y: y)
    }
    
    public init( _ x : CGFloat, _ y : CGFloat)
    {
        self.init( x : x, y: y)
    }
    
    public init( _ x : Float, _ y : Float)
    {
        self.init( x : CGFloat(x), y : CGFloat(y))
    }
    
    /// Perform the dot product on two vectors.
    public static func dot(a : CGPoint, _ b : CGPoint ) -> CGFloat
    {
        return a.x * b.x + a.y * b.y
    }
    
    /// Perform the cross product on two vectors. In 2D this produces a scalar.
    public static func cross( a : CGPoint, _ b : CGPoint ) -> CGFloat
    {
        return a.x * b.y - a.y * b.x
    }
    
    /// Perform the cross product on a vector and a scalar. In 2D this produces
    /// a vector.
    public static func cross( a a : CGPoint, s : CGFloat ) -> CGPoint
    {
        return CGPoint( x : s * a.y, y : -s * a.x )
    }
    
    /// Perform the cross product on a scalar and a vector. In 2D this produces
    /// a vector.
    public static func cross( s s : CGFloat, a : CGPoint ) -> CGPoint
    {
        return CGPoint( x : -s * a.y, y : s * a.x )
    }
    
    public static func distance(a a : CGPoint, b : CGPoint ) -> CGFloat
    {
        let c = a - b
        return c.length()
    }
    
    public static func distanceSquared( a : CGPoint, _ b : CGPoint ) -> CGFloat
    {
        let c = a - b
        return dot( c, c )
    }
    
    public mutating func setZero()
    {
        x = 0
        y = 0
    }
    
    public mutating func set( x x : CGFloat, y : CGFloat )
    {
        self.x = x
        self.y = y
    }

    public mutating func set ( p : CGPoint )
    {
        self.x = p.x
        self.y = p.y
    }

    /// Get the length of this vector (the norm).
    public func length() -> CGFloat
    {
        return sqrt( x * x + y * y )
    }
    
    /// Get the length squared. For performance, use this instead of
    /// CGPoint.length (if possible).
    public func lengthSquared() -> CGFloat
    {
        return x * x + y * y
    }
    
    /// Convert this vector into a unit vector. Returns the length.
    public mutating func normalize() -> CGFloat
    {
        let length = self.length()
        if length < CGFloat( FLT_EPSILON )
        {
            return 0.0;
        }
        
        let invLength = 1.0 / length
        x *= invLength
        y *= invLength
        
        return length
    }
    
    /// Does this vector contain finite coordinates?
    public func isValid() -> Bool
    {
        return x.isValid() && y.isValid()
    }
    
    /// Get the skew vector such that dot(skew_vec, other) == cross(vec, other)
    public func skew() -> CGPoint
    {
        return CGPoint( x : -y, y : x )
    }
}

/// Add two vectors component-wise.
public func + ( a :CGPoint, b : CGPoint ) -> CGPoint
{
    return CGPoint( x : a.x + b.x, y : a.y + b.y )
}

/// Subtract two vectors component-wise.
public func - ( a:CGPoint, b:CGPoint ) -> CGPoint
{
    return CGPoint( x : a.x - b.x, y : a.y - b.y )
}

public func * ( s : CGFloat, a : CGPoint ) -> CGPoint
{
    return CGPoint( x : s * a.x, y : s * a.y)
}

public func * ( a : CGPoint, s : CGFloat ) -> CGPoint
{
    return CGPoint( x : s * a.x, y : s * a.y)
}


public func == ( lhs : CGPoint, rhs : CGPoint ) -> Bool
{
    return lhs.x == rhs.x && lhs.y == rhs.y
}

/// Negate this vector.
public prefix func - ( v : CGPoint ) -> CGPoint
{
    return CGPoint( x : -v.x, y : -v.y )
}

/// Add a vector to this vector.
public func += ( inout left : CGPoint, right : CGPoint )
{
    left = left + right
}

/// Subtract a vector from this vector.
public func -= ( inout left : CGPoint, right : CGPoint )
{
    left = left - right
}

/// Multiply this vector by a scalar.
public func *= ( inout left : CGPoint, right : CGFloat )
{
    left.x *= right
    left.y *= right
}

public func abs( a : CGPoint ) -> CGPoint
{
    return CGPoint( x : abs( a.x ), y : abs (a.y ) )
}

public func min(a a : CGPoint, b : CGPoint ) -> CGPoint
{
    return CGPoint( x : min( a.x, b.x ), y : min( a.y, b.y ) )
}

public func max(a a : CGPoint, b : CGPoint ) -> CGPoint
{
    return CGPoint( x : max( a.x, b.x ), y : max( a.y, b.y ) )
}

public func clamp(a a:CGPoint, low : CGPoint, high : CGPoint ) -> CGPoint
{
    return max( a : low, b: min( a : a, b : high ) )
}
