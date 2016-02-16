//
//  SeparatorCollectionViewFlowLayout.swift
//  ChicByChoice
//
//  Created by Ivan Bruel on 10/12/15.
//  Copyright © 2015 Chic by Choice. All rights reserved.
//

import Foundation
import UIKit
import UICollectionViewLeftAlignedLayout

public class SeparatorCollectionViewFlowLayout: UICollectionViewLeftAlignedLayout {

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

  private static let topSeparatorKind = "SeparatorCollectionViewFlowLayout.Top"
  private static let bottomSeparatorKind = "SeparatorCollectionViewFlowLayout.Bottom"
  private static let leftSeparatorKind = "SeparatorCollectionViewFlowLayout.Left"
  private static let rightSeparatorKind = "SeparatorCollectionViewFlowLayout.Right"

  private static let separatorKinds = [leftSeparatorKind, rightSeparatorKind, topSeparatorKind,
    bottomSeparatorKind]

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
      forDecorationViewOfKind: SeparatorCollectionViewFlowLayout.topSeparatorKind)
    registerClass(SeparatorView.self,
      forDecorationViewOfKind: SeparatorCollectionViewFlowLayout.bottomSeparatorKind)
    registerClass(SeparatorView.self,
      forDecorationViewOfKind: SeparatorCollectionViewFlowLayout.leftSeparatorKind)
    registerClass(SeparatorView.self,
      forDecorationViewOfKind: SeparatorCollectionViewFlowLayout.rightSeparatorKind)
  }

  override public func layoutAttributesForDecorationViewOfKind(elementKind: String,
    atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
      super.layoutAttributesForDecorationViewOfKind(elementKind, atIndexPath: indexPath)

      var frame = CGRect.zero

      if let rows = collectionView?.numberOfItemsInSection(0) where indexPath.row < rows {
        if let cellAttributes = layoutAttributesForItemAtIndexPath(indexPath) {
          frame = cellAttributes.frame
        }
      }

      let layoutAttributes = ColoredViewLayoutAttributes(forDecorationViewOfKind: elementKind,
        withIndexPath: indexPath)

      switch elementKind {
      case SeparatorCollectionViewFlowLayout.rightSeparatorKind:
        layoutAttributes.frame = CGRect(x: frame.maxX,
          y: frame.minY - separatorWidth, width: separatorWidth,
          height: frame.height + separatorWidth * 2)
      case SeparatorCollectionViewFlowLayout.leftSeparatorKind:
        layoutAttributes.frame = CGRect(x: frame.minX - separatorWidth,
          y: frame.minY - separatorWidth, width: separatorWidth,
          height: frame.height + separatorWidth * 2)
      case SeparatorCollectionViewFlowLayout.topSeparatorKind:
        layoutAttributes.frame = CGRect(x: frame.minX,
          y: frame.minY - separatorWidth, width: frame.width,
          height: separatorWidth)
      case SeparatorCollectionViewFlowLayout.bottomSeparatorKind:
        layoutAttributes.frame = CGRect(x: frame.minX,
          y: frame.maxY, width: frame.width,
          height: separatorWidth)
      default:
        break
      }

      layoutAttributes.zIndex = -1
      if let rows = collectionView?.numberOfItemsInSection(0) where indexPath.row >= rows {
        layoutAttributes.color = UIColor.clearColor()
      } else {
        layoutAttributes.color = separatorColor
      }

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

        layoutAttributes += SeparatorCollectionViewFlowLayout.separatorKinds.flatMap {
          (kind) -> UICollectionViewLayoutAttributes? in
            layoutAttributesForDecorationViewOfKind(kind, atIndexPath: layoutAttribute.indexPath)
          }
      }

      return layoutAttributes
  }

}

private class ColoredViewLayoutAttributes: UICollectionViewLayoutAttributes {

  var color: UIColor = UIColor.clearColor()

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
