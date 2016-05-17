import CoreGraphics

@inline (__always) public func radiansToDegrees ( radians : CGFloat) -> CGFloat
{
    return radians * 180.0 / CGFloat( M_PI )
}

@inline (__always) public func degreesToRadians( degrees : CGFloat ) -> CGFloat
{
    return degrees * CGFloat( M_PI ) / 180.0
}

@inline (__always) public func radiansToDegrees ( radians : Float) -> Float
{
    return radians * 180.0 / Float( M_PI )
}

@inline (__always) public func degreesToRadians( degrees : Float ) -> Float
{
    return degrees * Float( M_PI ) / 180.0
}

@inline (__always) public func radiansToDegrees ( radians : Double) -> Double
{
    return radians * 180.0 / M_PI
}

@inline (__always) public func degreesToRadians( degrees : Double ) -> Double
{
    return degrees * M_PI / 180.0
}

@inline (__always) func sign(v:Int) -> Int
{
    return v < 0 ? -1 : 1
}

@inline (__always) func sign(v:Float) -> Float
{
    return v < 0 ? -1 : 1
}

@inline (__always) func sign(v:CGFloat) -> CGFloat
{
    return v < 0 ? -1 : 1
}

@inline (__always) func sign(v:Double) -> Double
{
    return v < 0 ? -1 : 1
}
