//
//  SeparatorCollectionViewFlowLayout.swift
//  ChicByChoice
//
//  Created by Ivan Bruel on 10/12/15.
//  Copyright © 2015 Chic by Choice. All rights reserved.
//

public class SeparatorCollectionViewFlowLayout: UICollectionViewLeftAlignedLayout {

    @IBInspectable var separatorWidth: CGFloat = 1 {
        didSet {
            invalidateLayout()
        }
    }

    @IBInspectable var separatorColor: UIColor = UIColor.black {
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

    init(separatorWidth: CGFloat = 1, separatorColor: UIColor = UIColor.black) {
        self.separatorWidth = separatorWidth
        self.separatorColor = separatorColor
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func prepare() {
        super.prepare()

        register(SeparatorView.self,
                      forDecorationViewOfKind: SeparatorCollectionViewFlowLayout.topSeparatorKind)
        register(SeparatorView.self,
                      forDecorationViewOfKind: SeparatorCollectionViewFlowLayout.bottomSeparatorKind)
        register(SeparatorView.self,
                      forDecorationViewOfKind: SeparatorCollectionViewFlowLayout.leftSeparatorKind)
        register(SeparatorView.self,
                      forDecorationViewOfKind: SeparatorCollectionViewFlowLayout.rightSeparatorKind)
    }

    override public func layoutAttributesForDecorationView(ofKind elementKind: String,
                                                           at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)

        var frame = CGRect.zero

        if let rows = collectionView?.numberOfItems(inSection: 0), indexPath.row < rows {
            if let cellAttributes = layoutAttributesForItem(at: indexPath) {
                frame = cellAttributes.frame
            }
        }

        let layoutAttributes = ColoredViewLayoutAttributes(forDecorationViewOfKind: elementKind,
                                                           with: indexPath)

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
        if let rows = collectionView?.numberOfItems(inSection: 0), indexPath.row >= rows {
            layoutAttributes.color = UIColor.clear
        } else {
            layoutAttributes.color = separatorColor
        }

        return layoutAttributes
    }

    override public func layoutAttributesForElements(in rect: CGRect)
        -> [UICollectionViewLayoutAttributes]? {
            guard let baseLayoutAttributes = super.layoutAttributesForElements(in: rect) else {
                return nil
            }

            var layoutAttributes = baseLayoutAttributes
            baseLayoutAttributes.filter { $0.representedElementCategory == .cell }.forEach {(layoutAttribute) in

                layoutAttributes += SeparatorCollectionViewFlowLayout.separatorKinds.flatMap {(kind) -> UICollectionViewLayoutAttributes? in
                    layoutAttributesForDecorationView(ofKind: kind, at: layoutAttribute.indexPath)
                }
            }

            return layoutAttributes
    }
}

private class ColoredViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var color: UIColor = UIColor.clear
}

private class SeparatorView: UICollectionReusableView {

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        guard let coloredLayoutAttributes = layoutAttributes as? ColoredViewLayoutAttributes else {
            return
        }
        backgroundColor = coloredLayoutAttributes.color
    }
}
