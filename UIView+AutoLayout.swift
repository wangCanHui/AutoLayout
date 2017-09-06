//
//  UIView+AutoLayout.swift
//  AutoLayout
//
//  Created by 王灿辉 on 2017/9/5.
//  Copyright © 2017年 王灿辉. All rights reserved.
//

import UIKit

public enum al_AlignType {
    case TopLeft
    case TopRight
    case TopCenter
    case BottomLeft
    case BottomRight
    case BottomCenter
    case CenterLeft
    case CenterRight
    case CenterCenter
    
    public func layoutAttributes(isInner: Bool, isVertical: Bool) -> al_LayoutAttributes {
        let attributes = al_LayoutAttributes()
        
        switch self {
        case .TopLeft:
            _ = attributes.horizontals(from: .left, to: .left).verticals(from: .top, to: .top)
            
            if isInner {
                return attributes
            } else if isVertical {
                return attributes.verticals(from: .bottom, to: .top)
            } else {
                return attributes.horizontals(from: .right, to: .left)
            }
        case .TopRight:
            _ = attributes.horizontals(from: .right, to: .right).verticals(from: .top, to: .top)
        
            if isInner {
                return attributes
            } else if isVertical {
                return attributes.verticals(from: .bottom, to: .top)
            } else {
                return attributes.horizontals(from: .left, to: .right)
            }
        case .TopCenter:        // 仅内部 & 垂直参照需要
            _ = attributes.horizontals(from: .centerX, to: .centerX).verticals(from: .top, to: .top)
            return isInner ? attributes : attributes.verticals(from: .bottom, to: .top)
        case .BottomLeft:
            _ = attributes.horizontals(from: .left, to: .left).verticals(from: .bottom, to: .bottom)
            
            if isInner {
                return attributes
            } else if isVertical {
                return attributes.verticals(from: .top, to: .bottom)
            } else {
                return attributes.horizontals(from: .right, to: .left)
            }
        case .BottomRight:
            _ = attributes.horizontals(from: .right, to: .right).verticals(from: .bottom, to: .bottom)
            
            if isInner {
                return attributes
            } else if isVertical {
                return attributes.verticals(from: .top, to: .bottom)
            } else {
                return attributes.horizontals(from: .left, to: .right)
            }
        case .BottomCenter:     // 仅内部 & 垂直参照需要
            _ = attributes.horizontals(from: .centerX, to: .centerX).verticals(from: .bottom, to: .bottom)
            return isInner ? attributes : attributes.verticals(from: .top, to: .bottom)
        case .CenterLeft:       // 仅内部 & 水平参照需要
            _ = attributes.horizontals(from: .left, to: .left).verticals(from: .centerY, to: .centerY)
            return isInner ? attributes : attributes.horizontals(from: .right, to: .left)
        case .CenterRight:      // 仅内部 & 水平参照需要
            _ = attributes.horizontals(from: .right, to: .right).verticals(from: .centerY, to: .centerY)
            return isInner ? attributes : attributes.horizontals(from: .left, to: .right)
        case .CenterCenter:     // 仅内部参照需要
            return al_LayoutAttributes(horizontal: .centerX, referHorizontal: .centerX, vertical: .centerY, referVertical: .centerY)
        }
    }
}

extension UIView{
    /// 填充子视图
    ///
    /// - Parameters:
    ///   - referView: 参考视图
    ///   - insets: 间距
    /// - Returns: 约束数组
    @discardableResult public func al_Fill(referView:UIView, insets:UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint]{
        translatesAutoresizingMaskIntoConstraints = false;
        
        var cons = [NSLayoutConstraint]();
        
        cons += NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(insets.left)-[subView]-\(insets.right)-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: ["subView":self])
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(insets.top)-[subView]-\(insets.bottom)-|", options: NSLayoutFormatOptions.alignAllLastBaseline, metrics: nil, views: ["subView":self])
        superview?.addConstraints(cons)
        
        return cons;
    }
    
    ///  参照参考视图内部对齐
    ///
    ///  - parameter type:      对齐方式
    ///  - Parameter referView: 参考视图
    ///  - Parameter size:      视图大小，如果是 nil 则不设置大小
    ///  - Parameter offset:    偏移量，默认是 CGPoint(x: 0, y: 0)
    ///
    ///  - returns: 约束数组
    @discardableResult public func al_AlignInner(type: al_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint]  {
        
        return al_AlignLayout(referView: referView, attributes: type.layoutAttributes(isInner: true, isVertical: true), size: size, offset: offset)
    }
    
    ///  参照参考视图垂直对齐
    ///
    ///  - parameter type:      对齐方式
    ///  - parameter referView: 参考视图
    ///  - parameter size:      视图大小，如果是 nil 则不设置大小
    ///  - parameter offset:    偏移量，默认是 CGPoint(x: 0, y: 0)
    ///
    ///  - returns: 约束数组
    @discardableResult public func al_AlignVertical(type: al_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint] {
        
        return al_AlignLayout(referView: referView, attributes: type.layoutAttributes(isInner: false, isVertical: true), size: size, offset: offset)
    }
    
    ///  参照参考视图水平对齐
    ///
    ///  - parameter type:      对齐方式
    ///  - parameter referView: 参考视图
    ///  - parameter size:      视图大小，如果是 nil 则不设置大小
    ///  - parameter offset:    偏移量，默认是 CGPoint(x: 0, y: 0)
    ///
    ///  - returns: 约束数组
    @discardableResult public func al_AlignHorizontal(type: al_AlignType, referView: UIView, size: CGSize?, offset: CGPoint = CGPoint.zero) -> [NSLayoutConstraint] {
        
        return al_AlignLayout(referView: referView, attributes: type.layoutAttributes(isInner: false, isVertical: false), size: size, offset: offset)
    }
    
    ///  在当前视图内部水平平铺控件
    ///
    ///  - parameter views:  子视图数组
    ///  - parameter insets: 间距
    ///
    ///  - returns: 约束数组
    @discardableResult public func al_HorizontalTile(views: [UIView], insets: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        
        assert(!views.isEmpty, "views should not be empty")
        
        var cons = [NSLayoutConstraint]()
        
        let firstView = views[0]
        _ = firstView.al_AlignInner(type: al_AlignType.TopLeft, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: firstView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -insets.bottom))
        
        // 添加后续视图的约束
        var preView = firstView
        for i in 1..<views.count {
            let subView = views[i]
            cons += subView.al_sizeConstraints(referView: firstView)
            _ = subView.al_AlignHorizontal(type: al_AlignType.TopRight, referView: preView, size: nil, offset: CGPoint(x: insets.right, y: 0))
            preView = subView
        }
        
        let lastView = views.last!
        cons.append(NSLayoutConstraint(item: lastView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -insets.right))
        
        addConstraints(cons)
        return cons
    }
    
    ///  在当前视图内部垂直平铺控件
    ///
    ///  - parameter views:  子视图数组
    ///  - parameter insets: 间距
    ///
    ///  - returns: 约束数组
    @discardableResult public func al_VerticalTile(views: [UIView], insets: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        
        assert(!views.isEmpty, "views should not be empty")
        
        var cons = [NSLayoutConstraint]()
        
        let firstView = views[0]
        _ = firstView.al_AlignInner(type: al_AlignType.TopLeft, referView: self, size: nil, offset: CGPoint(x: insets.left, y: insets.top))
        cons.append(NSLayoutConstraint(item: firstView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -insets.right))
        
        // 添加后续视图的约束
        var preView = firstView
        for i in 1..<views.count {
            let subView = views[i]
            cons += subView.al_sizeConstraints(referView: firstView)
            _ = subView.al_AlignVertical(type: al_AlignType.BottomLeft, referView: preView, size: nil, offset: CGPoint(x: 0, y: insets.bottom))
            
            preView = subView
        }
        
        let lastView = views.last!
        cons.append(NSLayoutConstraint(item: lastView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -insets.bottom))
        
        addConstraints(cons)
        
        return cons
    }
    
    ///  从约束数组中查找指定 attribute 的约束
    ///
    ///  - parameter constraintsList: 约束数组
    ///  - parameter attribute:       约束属性
    ///
    ///  - returns: attribute 对应的约束
    @discardableResult public func al_Constraint(constraintsList: [NSLayoutConstraint], attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        for constraint in constraintsList {
            if constraint.firstItem as! NSObject == self && constraint.firstAttribute == attribute {
                return constraint
            }
        }
        
        return nil
    }
    
    // MARK: - 私有方法
    
    ///  参照参考视图对齐布局
    ///
    ///  - parameter referView:  参考视图
    ///  - parameter attributes: 参照属性
    ///  - parameter size:       视图大小，如果是 nil 则不设置大小
    ///  - parameter offset:     偏移量，默认是 CGPoint(x: 0, y: 0)
    ///
    ///  - returns: 约束数组
    private func al_AlignLayout(referView: UIView, attributes: al_LayoutAttributes, size: CGSize?, offset: CGPoint) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        
        cons += al_positionConstraints(referView: referView, attributes: attributes, offset: offset)
        
        if size != nil {
            cons += al_sizeConstraints(size: size!)
        }
        
        superview?.addConstraints(cons)
        
        return cons
    }
    
    
    ///  尺寸约束数组
    ///
    ///  - parameter size: 视图大小
    ///
    ///  - returns: 约束数组
    private func al_sizeConstraints(size: CGSize) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.width))
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.height))
        
        return cons
    }
    
    ///  尺寸约束数组
    ///
    ///  - parameter referView: 参考视图，与参考视图大小一致
    ///
    ///  - returns: 约束数组
    private func al_sizeConstraints(referView: UIView) -> [NSLayoutConstraint] {
        
        var cons = [NSLayoutConstraint]()
        
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0))
        cons.append(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0))
        
        return cons
    }
    
    ///  位置约束数组
    ///
    ///  - parameter referView:  参考视图
    ///  - parameter attributes: 参照属性
    ///  - parameter offset:     偏移量
    ///
    ///  - returns: 约束数组
    private func al_positionConstraints(referView: UIView, attributes: al_LayoutAttributes, offset: CGPoint) -> [NSLayoutConstraint]{
        translatesAutoresizingMaskIntoConstraints = false;
        
        var cons = [NSLayoutConstraint]()
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.horizontal, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: attributes.referHorizontal, multiplier: 1.0, constant: offset.x))
        cons.append(NSLayoutConstraint(item: self, attribute: attributes.vertical, relatedBy: NSLayoutRelation.equal, toItem: referView, attribute: attributes.referVertical, multiplier: 1.0, constant: offset.y))
        
        return cons
    }
    
}

///  布局属性
public final class al_LayoutAttributes {
    var horizontal:         NSLayoutAttribute
    var referHorizontal:    NSLayoutAttribute
    var vertical:           NSLayoutAttribute
    var referVertical:      NSLayoutAttribute
    
    init() {
        horizontal = NSLayoutAttribute.left
        referHorizontal = NSLayoutAttribute.left
        vertical = NSLayoutAttribute.top
        referVertical = NSLayoutAttribute.top
    }
    
    init(horizontal: NSLayoutAttribute, referHorizontal: NSLayoutAttribute, vertical: NSLayoutAttribute, referVertical: NSLayoutAttribute) {
        
        self.horizontal = horizontal
        self.referHorizontal = referHorizontal
        self.vertical = vertical
        self.referVertical = referVertical
    }
    
    public func horizontals(from: NSLayoutAttribute, to: NSLayoutAttribute) -> Self {
        horizontal = from
        referHorizontal = to
        
        return self
    }
    
    public func verticals(from: NSLayoutAttribute, to: NSLayoutAttribute) -> Self {
        vertical = from
        referVertical = to
        
        return self
    }
}
