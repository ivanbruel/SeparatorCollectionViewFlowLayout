//
//  SeparatorCollectionViewFlowLayout.swift
//
//  Created by Ivan Bruel on 10/12/15.
//

import Foundation
import UIKit

public class SeparatorCollectionViewFlowLayout: UICollectionViewFlowLayout {

  @IBInspectable var separatorWidth: CGFloat = 1 {
    didSet {
      invalidateLayout()
    }
  }

  @IBInspectable var separatorColor: UIColor = UIColor.blackColor() {
    didSet {
      invalidateLayout()
    }
  }

  init(separatorWidth: CGFloat = 1, separatorColor: UIColor = UIColor.blackColor()) {
    self.separatorWidth = separatorWidth
    self.separatorColor = separatorColor
    super.init()
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  override public class func layoutAttributesClass() -> AnyClass {
    return ColoredViewLayoutAttributes.self
  }

  override public func prepareLayout() {
    super.prepareLayout()

    registerClass(SeparatorView.self,
      forDecorationViewOfKind: SeparatorKind.topSeparator)
    registerClass(SeparatorView.self,
      forDecorationViewOfKind: SeparatorKind.bottomSeparator)
    registerClass(SeparatorView.self,
      forDecorationViewOfKind: SeparatorKind.rightSeparator)
    registerClass(SeparatorView.self,
      forDecorationViewOfKind: SeparatorKind.leftSeparator)
  }

  override public func layoutAttributesForDecorationViewOfKind(elementKind: String,
    atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
      super.layoutAttributesForDecorationViewOfKind(elementKind, atIndexPath: indexPath)

      guard let cellAttributes = layoutAttributesForItemAtIndexPath(indexPath) else {
        return nil
      }

      let layoutAttributes = ColoredViewLayoutAttributes(forDecorationViewOfKind: elementKind,
        withIndexPath: indexPath)

      let baseFrame = cellAttributes.frame

      guard let transformedFrame = SeparatorKind.init(rawValue: elementKind)?.transform(frame: baseFrame, with: separatorWidth) else {
        return nil
      }

      layoutAttributes.frame = transformedFrame

      layoutAttributes.zIndex = -1
      layoutAttributes.color = separatorColor

      return layoutAttributes
  }

  override public func layoutAttributesForElementsInRect(rect: CGRect)
    -> [UICollectionViewLayoutAttributes]? {
      guard let baseLayoutAttributes = super.layoutAttributesForElementsInRect(rect) else {
        return nil
      }

      var layoutAttributes = baseLayoutAttributes
      baseLayoutAttributes.filter { $0.representedElementCategory == .Cell }.forEach {
        (layoutAttribute) -> () in

        layoutAttributes += SeparatorKind.elements.flatMap { (kind) -> UICollectionViewLayoutAttributes? in
          layoutAttributesForDecorationViewOfKind(kind.rawValue, atIndexPath: layoutAttribute.indexPath)
        }
      }

      return layoutAttributes
  }

}

private class ColoredViewLayoutAttributes: UICollectionViewLayoutAttributes {

  var color: UIColor = UIColor.blackColor()

}

private class SeparatorView: UICollectionReusableView {

  override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
    super.applyLayoutAttributes(layoutAttributes)

    guard let coloredLayoutAttributes = layoutAttributes as? ColoredViewLayoutAttributes else {
      return
    }

    backgroundColor = coloredLayoutAttributes.color
  }

}

private enum SeparatorKind: String {
  case topSeparator = "SeparatorCollectionViewFlowLayout.Top"
  case bottomSeparator = "SeparatorCollectionViewFlowLayout.Bottom"
  case leftSeparator = "SeparatorCollectionViewFlowLayout.Left"
  case rightSeparator = "SeparatorCollectionViewFlowLayout.Right"

  static var elements: [SeparatorKind] {
    get {
      return [.leftSeparator, .rightSeparator, .topSeparator, .bottomSeparator]
    }
  }

  func transform(frame baseFrame: CGRect, with separatorWidth: CGFloat) -> CGRect {
    switch self {

    case .topSeparator:
      return CGRect(x: baseFrame.minX, y: baseFrame.minY - separatorWidth, width: baseFrame.width, height: separatorWidth)

    case .bottomSeparator:
      return CGRect(x: baseFrame.minX, y: baseFrame.maxY, width: baseFrame.width, height: separatorWidth)

    case .leftSeparator:
      return CGRect(x: baseFrame.minX - separatorWidth, y: baseFrame.minY - separatorWidth, width: separatorWidth, height: baseFrame.height + separatorWidth * 2)

    case .rightSeparator:
      return CGRect(x: baseFrame.maxX, y: baseFrame.minY - separatorWidth, width: separatorWidth, height: baseFrame.height + separatorWidth * 2)
    }
  }
}

extension UICollectionViewFlowLayout {
  private func registerClass(viewClass: AnyClass?, forDecorationViewOfKind elementKind: SeparatorKind) {
    registerClass(viewClass, forDecorationViewOfKind: elementKind.rawValue)
  }
}
