import UIKit

extension String
{
    subscript ( i : Int) -> Character
    {
        return self[ self.startIndex.advancedBy( i ) ]
    }

    subscript ( i : Int) -> String
    {
        return String( self[ i ] as Character )
    }
    
    public static func unique() -> String
    {
        return NSUUID().UUIDString
    }
}

extension Character
{
    func unicodeScalarCodePoint() -> UInt32
    {
        let characterString = String( self )
        let scalars = characterString.unicodeScalars
        return scalars[ scalars.startIndex ].value
    }
}

extension String
{
    func unicodeScalarCodePoint() -> UInt32
    {
        let scalars = unicodeScalars
        return scalars[ scalars.startIndex ].value
    }
}

import Darwin

extension Int
{
    static func random() -> Int
    {
        return Int( arc4random() )
    }
    
    static func random( range : Range<Int> ) -> Int
    {
        return Int( arc4random_uniform( UInt32( range.endIndex - range.startIndex ) ) ) + range.startIndex
    }
}

public extension Double
{
    public static func random() -> Double
    {
        return drand48()
    }
}

public extension Float
{
    public static let PI = Float( M_PI )
    
    public static func random() -> Float
    {
        return Float( arc4random() % UInt32.max ) / Float( UInt32.max )
    }
    
    public func isValid() -> Bool
    {
        return isfinite( self ) && !isnan( self )
    }
}

public func * ( a : Int, s : Float ) -> Float
{
    return Float( a ) * s
}

public func * ( lhs : Float, rhs : Int ) -> Float
{
    return lhs * Float( rhs )
}

//http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861
public func delay(delay:Double, closure:()->()) {
    dispatch_after(
    dispatch_time(
    DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
    ),
            dispatch_get_main_queue(), closure)
}

public extension Array
{
    func random() -> Element
    {
        return self[Int(arc4random_uniform(UInt32(self.count)))]
    }
}
