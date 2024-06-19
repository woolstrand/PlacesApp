# Places app

## App structure
The app is built using MVVM pattern. Service layer includes model objects (just Location) and three services: API (for getting and decoding remote data), Storage (for keeping track of what locations are there in the app) and ExternalAction to perform actions ouside of the app. Each service has a protocol and two implementations: a default one and a mock one. Mocks are used for testing and for previews while real are used in the app. In larger apps there could be more complex dependencies between services and it's reasonable to use DI container and a specialized App Constructor object to maintain all cross-references. In this exercise the structure is pretty flat, so all services are created in the app main scene.

To demonstrate concurrency I used async/await approach in API service and I used DispatchQueues to employ thread safety in Storage Service. I'm aware that DispatchQueues and async/await do not go well together, so I would try to not use them inside the same module, but since those are different services and my purpose was to provides some examples, that's fine. I could also implement thread safety using actors or I can use dispatch queues and completion closures in API to make things consistent.

Storage service can be extended to store information between launches.

Since the app has just two screens (list and add new place), there is no dedicated entity for coordinating transitions. In a real life app I'd rather not use built in swift navigation as I don't thing it is mature enough to be used in business apps. Coordinator with custom routes and internally kept UIKit based navigation stack would fit well for that task, but writing a good coordinator can take much more time than the whole that task, so I chose a simple way here.

What I do not like about the overall behavior of the app is that the original data file does not have any kind of IDs for objects. This means there could be problems dealing with duplicates and there is no reliable way to update an item. So in the current implementation I eliminate complete duplicates and keep all other objects in place. If the app should be expanded to provide data renewal from the remote file, the first thing to be introduced is internal IDs.

 ## UI
 The app has a simple refreshable list UI for the main page and a simple form UI for the second page.
 Interaction between viewModels is done via combine. Publisher is a part of a new location screen so it does not require any unnecessary dependencies between screens.
 
 ## Testing
 The app is a bit too simple to have some interesting tests, but anyway.
 I do not test APIService, because we should not write tests which are not reproducable, and when we're relying on something remote we can't talk about reproducability.
 I do not test ExternalActionService on similar reason: we can't check the outcome of the only call it supports.
 However, ExternalActionService could be configured with an `any URLOpener` class, so we can divide responsibity of ExternalActionService into two parts: "convert location to URL" and "Open URL", and after that, mocking URLOpener, we could check just the conversion part for validity. 
 Also, Storage Service can be tested, and list view model can be tested as well. LocationsList.ViewModel is initialized with mocks to isolate its own logic from its dependencies.  

