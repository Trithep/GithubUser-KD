//
//  UIView+Extension.swift
//  Core
//

import UIKit

extension UIView {
    
    @IBInspectable var borderUIColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var borderUIWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerUIRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    public func addSubViewWithoutLayoutIfNeeded(_ view: UIView, padding: CGFloat = 0) {
         
         view.translatesAutoresizingMaskIntoConstraints = false
         addSubview(view)
         
         view.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
         view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: padding).isActive = true
         view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
         view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: padding).isActive = true
     }
    
    public func addSubViewWithAutoLayout(_ view: UIView, padding: CGFloat = 0, onlyLeftRight: Bool = false) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        if onlyLeftRight {
            view.topAnchor.constraint(equalTo: topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1*padding).isActive = true
        } else {
            view.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1*padding).isActive = true
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1*padding).isActive = true
        }
        
        
        layoutIfNeeded()
    }
    
    public func addSubViewWithoutTopConstraint(_ view: UIView, height: CGFloat) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        layoutIfNeeded()
    }
    
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    public func loadFromNib<T: UIView>(bundle: Bundle) -> T {
        let named = String(describing: T.self)
        return UINib(nibName: named, bundle: bundle).instantiate(withOwner: self, options: nil)[0] as! T
    }
}
