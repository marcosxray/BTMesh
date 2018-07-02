# BTMesh
An iOS/Swift framework to create mesh networks over Bluetooth Low Energy(BLE).
</br></br>
# Installation
To install using Cocoapods, please add the following line to your Podfile:</br>
pod 'BTMesh', :git => 'https://github.com/marcosxray/BTMesh', :tag => '0.0.7'
</br></br>
* Run "pod install" command on your project directory, using a terminal application.
</br></br>
* Do a "import BTMesh" on your .swift file.
</br></br>
* Set BTRouter.config, passing identifier strings for the main service, and the 3 basic characteristics (Identification, Route_update and Message):</br>
BTRouter.config = BTRouterConfig(service_ID: "UUID",
                                         identification_ID: "UUID",
                                         route_update_RX_ID: "UUID",
                                         message_RX_ID: "UUID")
# Demo
The demo application shows how to use BTMesh framework in your project:
</br></br>
<img src="https://github.com/marcosxray/BTMesh/blob/master/Docs/chat.png" alt="Demo app">
</br></br>
# Unit testing
If you want to know more about BTMesh' <a href="https://github.com/marcosxray/BTMesh/blob/master/Docs/UnitTesting.md">unit tests</a>, please visit the documentation.
