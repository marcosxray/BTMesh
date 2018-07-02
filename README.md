# BTMesh
An iOS/Swift framework to create mesh networks over Bluetooth Low Energy(BLE).
</br></br>
# Installation
To install using Cocoapods, please do the following:
</br>
* Add this line to your Podfile:</br>
pod 'BTMesh', :git => 'https://github.com/marcosxray/BTMesh', :tag => '0.0.7'
</br></br>
* Run "pod install" command on your project's directory, using a terminal application.
</br></br>
# Usage
* Do a "import BTMesh" on your .swift file.

* Set BTRouter.config before calling BTRouter singleton (BTRouter.shared), passing identifier strings for the main service, and the 3 basic characteristics (Identification, Route_update and Message):

BTRouter.config = BTRouterConfig(service_ID: "UUID",
                                         identification_ID: "UUID",
                                         route_update_RX_ID: "UUID",
                                         message_RX_ID: "UUID")

* Call "BTRouter.shared.start()" to start broadcasting and scanning for other devices using the same service (service_ID).

* "BTStorage.shared.users" is a BehaviorSubject that if fired every time a user is added or remove from the system. Just use it as your main data source to retrieve all visible users.
</br></br>
# Demo
The demo application shows how to use BTMesh framework in your project:
</br></br>
<img src="https://github.com/marcosxray/BTMesh/blob/master/Docs/chat.png" alt="Demo app" width="640">
</br></br>
# Unit testing
If you want to know more about BTMesh' <a href="https://github.com/marcosxray/BTMesh/blob/master/Docs/UnitTesting.md">unit tests</a>, please visit the documentation.
