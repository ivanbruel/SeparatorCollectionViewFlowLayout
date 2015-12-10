Moya-SeparatorCollectionViewFlowLayout
============
[![CocoaPods](https://img.shields.io/cocoapods/v/SeparatorCollectionViewFlowLayout.svg)](https://github.com/ivanbruel/SeparatorCollectionViewFlowLayout)

A UICollectionViewFlowLayout implementation to allow separators between cells.

![Example](http://i.imgur.com/MePIPmA.png)

# Installation

## Cocoapods

`pod 'SeparatorCollectionViewFlowLayout', '~> 1.0'`

# Usage

## 1. Programatically

```swift
import Foundation
import UIKit
import SeparatorCollectionViewFlowLayout

// MARK: Initializer and Properties
class SomeViewController: UIViewController: UICollectionViewDataSource, UICollectionViewDelegate {

  let collectionView: UICollectionView
  let separatorCollectionViewFlowLayout: SeparatorCollectionViewFlowLayout

  init() {
    separatorCollectionViewFlowLayout = SeparatorCollectionViewFlowLayout(separatorWidth: 1.0, separatorColor: UIColor.grayColor())
    collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: separatorCollectionViewFlowLayout)

    super.init(nibName: nil, bundle: nil)

    collectionView.delegate = self
    collectionView.dataSource = self

    view.addSubview(collectionView)
  }

  ...
}
```

## 2. Storyboard

Just change the default class of your `UICollectionViewFlowLayout` to `SeparatorCollectionViewFlowLayout` and set the `Separator Width` and `Separator Color` properties.

![Example](http://i.imgur.com/ZRZMbfU.png)

# Contributing

Issues and pull requests are welcome!

# Author

Ivan Bruel [@ivanbruel](https://twitter.com/ivanbruel)

# License

SeparatorCollectionViewFlowLayout is released under an MIT license. See LICENSE for more information.
