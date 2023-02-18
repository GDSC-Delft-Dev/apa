# APA Mobile App
This mobile application - created using `Flutter` - aims to provide farmers with localized insights about their fields, by using drone technology to capture multi-spectral images of their crops. 
Insights are generated by our image processing pipeline, as well as our high-fidelity agricultural data source.   
Through an intuitive dashboard, farmers are able to automatically track historical field status. 
We are striving for additional tablet support in the near future.

<p align="center">
    <p align="center">
        <img src="https://user-images.githubusercontent.com/74115586/219355950-a4476798-28a1-4ca1-aa8b-85b7556fc3fe.png" width="450" />
        &nbsp &nbsp
        <img src="https://user-images.githubusercontent.com/74115586/219356529-b53a18b4-6995-4cd0-9b3e-4c054c97cd46.png" width="300" />
         &nbsp &nbsp
        <img src="https://user-images.githubusercontent.com/74115586/219357528-0ea762fe-0228-4e00-8d6e-9baad15b8fbc.png" width="470" />
         &nbsp &nbsp
        <img src="https://user-images.githubusercontent.com/74115586/219357760-b6b828e5-6330-4898-82cd-9eb31c03e607.png" width="300" />
        &nbsp &nbsp
        <img src="https://user-images.githubusercontent.com/74115586/219358000-6267bbd4-87cf-40ec-8459-26cc5ff6af04.png" width="400" />
    </p>
</p>

<p align="center">Example wireframes</p>


## Getting started

### Step 1

Download or clone this repository by using the following link: 
`https://github.com/GDSC-Delft-Dev/apa.git`

### Step 2

Navigate to the Flutter project root `.../apa/src/frontend` and download dependencies for the Flutter project from Pub (package manager for Dart) by entering the following in your Flutter console:
````
flutter pub get
````
Optionally: upgrade the dependencies for the Flutter project to the latest available versions
````
flutter pub upgrade
````

### Step 3

Run the Flutter project on an attached device or emulator:
````
flutter run
````

### Useful Flutter commands

Clean the build files generated by Flutter, which can help to resolve issues with the build process
````
flutter clean
````
Build a release version of the app for deployment:
````
flutter build
````
Run unit and widget tests for the Flutter project:
````
flutter test
````
Get information about installed tooling required for Flutter development
````
flutter doctor
````


## How to use

In order to be able to use Google Maps API, several steps need to be taken with regards to private key configuration.

- Create an account in https://console.developers.google.com/ and add our APA project (if not done so yet), in order to fetch your private API key for Google Maps.
- To run on Android - add the following to the `src/frontend/android/local.properties` file:
````
GMapsAPIKey={YOUR_PRIVATE_GOOGLE_MAPS_API_KEY}
````` 
- To run on iOS - add the following to the `src/frontend/ios/Flutter/Debug.xcconfig` file:
```` 
#include "Generated.xcconfig"
GOOGLE_MAPS_API_KEY={YOUR_PRIVATE_GOOGLE_MAPS_API_KEY}
````
Note that `local.properties` and `Debug.xcconfig` are both under `.gitignore`.
- To access env vars from source code - create a `.env` file under the `lib` directory with the following contents:
````
GOOGLE_MAPS_API_KEY={YOUR_PRIVATE_GOOGLE_MAPS_API_KEY}
````

## Tools and Libraries Used
- [Google Maps Platform](https://mapsplatform.google.com/)
- [Firebase](https://firebase.google.com/) - Authentication, Cloud Firestore, hosting
- [Google Cloud Storage](https://cloud.google.com/storage)
- [Cloud Functions](https://cloud.google.com/functions)

## Folder Structure

Below is visualized the default folder structure provided by Flutter:
````
flutter-app/
|- android
|- build
|- ios
|- lib
|- test
````

Folder structure used by us:
````
lib/
|- models/ - Contains data models
|- services/ - Contains API endpoints
|- views/ - Contains all the UI screens of the application
|- widgets/ - Contains the common widgets used in the application
| - stores/ - Contains store(s) for state-management of your application, to connect the reactive data of your application with the UI
|- utils/ - Contains the common utility functions of the application
|- main.dart - Starting point of the application - all the application level configurations are defined in this file i.e, theme, routes, title, orientation etc.
````

## Routes
The following routes are defined in `main.dart`
````
      routes: {
        '/': (context) => const MainPage(),
        '/load': (context) => Loading(),
        '/home': (context) => const Home(title: 'APA'),
        '/add': (context) => const AddField(),
        '/fields': (context) => const MyFields(),
        '/fly': (context) => const FlyDrone(droneName: 'DJI Mavic 3',),
        '/settings': (context) => const Settings(),
      }
````

<!-- ## Data models
## Services
## Views
## Utils
## Widgets
## Utils
 -->