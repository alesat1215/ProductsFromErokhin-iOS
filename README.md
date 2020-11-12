# Products From Erokhin

Application use Model-View-ViewModel (MVVM) architecture with [Firebase](https://firebase.google.com/docs/ios/setup), [Core Data](https://developer.apple.com/documentation/coredata) and [RxSwift](https://github.com/ReactiveX/RxSwift).\
For dependency injection used [Swinject](https://github.com/Swinject/Swinject).

## Single source of truth [(SSOT)](https://en.wikipedia.org/wiki/Single_source_of_truth)

Reactive programming style allows get request to [Core Data](https://developer.apple.com/documentation/coredata), observe for changes in view context and update the database, if needed, from [Firebase Remote Config](https://firebase.google.com/docs/remote-config/use-config-ios) in background context.\
[DatabaseUpdater](https://github.com/alesat1215/ProductsFromErokhin-iOS/blob/master/ProductsFromErokhin/Data/DatabaseUpdater.swift) sync local database with remote. More about it in [habr.com](https://habr.com/ru/post/524508/).\
[Repository](https://github.com/alesat1215/ProductsFromErokhin-iOS/blob/master/ProductsFromErokhin/Data/Repository.swift) get data and realize [(SSOT)](https://en.wikipedia.org/wiki/Single_source_of_truth).\
Images loading from [Firebase Storage](https://firebase.google.com/docs/storage/ios/start) by [SDWebImage](https://github.com/SDWebImage/SDWebImage).
