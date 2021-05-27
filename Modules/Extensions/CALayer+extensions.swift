import Foundation

public extension CALayer {
    func applySketchShadow(color: UIColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1),
                           alpha: Float = 0.7,
                           xOffset: CGFloat = 0,
                           yOffset: CGFloat = 5,
                           blur: CGFloat = 0,
                           spread: CGFloat = 0) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: xOffset, height: yOffset)
        shadowRadius = blur / 2.0
        
        if spread == 0 {
            shadowPath = nil
        } else {
            let dxVal = -spread
            let rect = bounds.insetBy(dx: dxVal, dy: dxVal)
            var radius = cornerRadius
            
            if let mask = mask {
                radius = mask.cornerRadius
            }
            
            shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
        }
    }
}
