# VibelyUI for iOS

[![SPM Compatible](https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat-square)](https://github.com/heyaibek/vibely-ui-ios)
[![License](https://img.shields.io/github/license/heyaibek/vibely-ui-ios.svg?style=flat-square)](https://github.com/heyaibek/vibely-ui-ios)

A collection of SwiftUI components used in [Vibely - Music Visualizer](https://apps.apple.com/app/id1528056717) app.

![Showcase](/Showcase.png "Vibely UI for iOS")

## Requirements

- iOS 15+
- Xcode 15.1+
- Swift 5.3+

## Installation

### Swift Package Manager

To integrate VibelyUI into your Xcode project using [Swift Package Manager](https://github.com/apple/swift-package-manager), open dependency manager through `File > Swift Packages > Add Package Dependency...` and insert repository URL:

`https://github.com/heyaibek/vibely-ui-ios.git`

To add dependency in your own package, just specify it in dependencies of your `Package.swift`:

```swift
.package(
  name: "VibelyUI",
  url: "https://github.com/heyaibek/vibely-ui-ios.git",
  .upToNextMajor(from: "<LATEST_VERSION>")
)
```

## Usage

```swift
import SwiftUI
import VibelyUI

struct ExampleView: View {
	@State private var value = CGFloat(0)

	var body: some View {
		VStack {
			CenterSlider(value: $value, range: -50 ... 50)
			ToolButton("Click Me", icon: .systemPlus) {}
		}
	}
}
```

For more usage examples check out [Showcase](/Sources/VibelyUI/Showcase) folder.

## Contribution

I'm excited to invite you to contribute to **Vibely UI**, my open-source SwiftUI package designed to enhance your development experience. You can help with contributions like:

* Add new features
* Fix bugs
* Improve documentation
* Review code
* Create examples/tutorials
* etc.

## License

MIT License

Copyright (c) 2024 Aibek Mazhitov

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
