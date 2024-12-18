### **1\. Introduction**

The **Price Checker** is a simple mobile application built using Flutter for the Android platform. The primary purpose of the app is to allow users to check and compare the prices of products from different sources. It provides a straightforward interface where users can view real-time product prices and make more informed decisions when shopping online.

This application is designed to run solely on Android devices, leveraging Flutter’s cross-platform development framework to ensure optimal performance and responsiveness on Android devices. The app fetches product data from a backend database, and displays it in an organized, user-friendly format.

This documentation is intended for the development team, especially for the future developers who may work on or continue the project. It provides an overview of the app’s internal structure, the role of each file, and how to maintain and expand the application. Since this app is a small project with only a few components, it is easy to understand and modify. The focus of this documentation is on the codebase, structure, and functionality to ensure a smooth handover to any future developers.

---

### **2\. Project Overview**

The **Price Checker** app is a simple Android application built with Flutter. It is designed to help users compare the prices of products by retrieving and displaying data from a backend database. The app is lightweight, easy to navigate, and built for efficient use of resources, ensuring a smooth user experience.

The project is structured in a way that each component serves a specific purpose, making it easy for developers to understand, maintain, and extend. The app uses Firebase as a backend to store and retrieve product data. It supports a basic user interface for interacting with the data and offers functionality to retrieve the product details by querying the database.

The project consists of six core Dart files, each playing a crucial role in the application’s operation:

* **`build_result_card.dart`**: This file creates a widget that displays individual pricing information for each product. Each card shows details such as the product name, price, and possibly a link to the product on the online platform.  
* **What it does**:  
  * Generates cards that display product price information.  
  * Each card represents a different product with its corresponding data.  
* **`configuration_screen.dart`**: This file contains the configuration screen of the app. It allows the user to configure settings, such as adding or removing product sources, adjusting preferences, or modifying other app settings.  
* **What it does**:  
  * Provides an interface for the user to adjust settings.  
  * It is a simple form screen where users can interact with app configurations.  
* **`db_connection.dart`**: This file handles the connection to the database. It is essential for fetching the product price data stored in the backend. It ensures that the app can securely retrieve and store information from the database.  
* **What it does**:  
  * Manages the connection to the database.  
  * Contains methods for retrieving product price data from the database.  
* **`main.dart`**: This is the entry point of the app. It initializes the Flutter framework and sets up the initial screen. Typically, it will include the MaterialApp widget and the main navigation route.  
* **What it does**:  
  * It loads the home screen when the app is launched.  
  * Initializes routing and the main widget that contains the app’s UI.  
* **`password.dart`**: The `password.dart` file is where the app handles user authentication. This could involve setting a password or validating it to ensure the user has proper access to the app or certain features within it.  
* **What it does**:  
  * Manages user authentication by prompting for a password.  
  * Ensures that only authenticated users can access certain parts of the app.  
* **`table_screen.dart`**: This screen is responsible for displaying the pricing data to the user in a table format. The table shows the product name, price, and source, making it easy for the user to compare prices.  
* **What it does**:  
  * Displays the product pricing information retrieved from the database.  
  * Presents the data in a well-organized table format.

---

### **Important Files in the `android` Folder**

#### **1\. `app/build.gradle`**

This file contains the build configuration for the Android application. It defines how the app is built, including settings related to dependencies, build types, and other Android-specific configurations. Key sections of this file include:

* **Dependencies**: Lists the libraries or SDKs required by the app, including Flutter-specific dependencies.  
* **Build Types**: Defines different build configurations, such as `debug` and `release`. The `release` build type is particularly important for production, where code is optimized and signed.  
* **Signing Config**: Specifies the signing credentials for building the app, such as the keystore and key alias, which are used to sign the APK or AAB for release.

#### **2\. `key.jks`**

This is the **Java Keystore (JKS)** file used for signing the Android APK or AAB during the build process. It ensures that the app is securely signed and that the app can be identified as being developed by your organization. The key store is required when generating a signed release build for the app, which is necessary for distribution on the Google Play Store or for internal distribution.

* **Key Alias**: An alias used to reference the key inside the keystore.  
* **Key Password**: The password associated with the specific key inside the keystore.  
* **Keystore Password**: The password used to protect the entire keystore file.

#### **3\. `proguard-rules.pro`**

This file contains **ProGuard rules**, which define how the code should be obfuscated, optimized, and minified during the build process. It is used for production builds (especially release builds) to reduce the APK size and protect the code from reverse engineering. Some important functions of this file include:

* **Minification**: Reduces the size of the APK by removing unused code.  
* **Obfuscation**: Renames classes, methods, and fields to make the code more difficult to read and reverse engineer.  
* **Optimization**: Performs optimizations on the bytecode to improve performance.

#### **4\. `AndroidManifest.xml` (in `app/src/main`)**

The `AndroidManifest.xml` file is a crucial configuration file for any Android application. It defines essential information about the app, such as:

* **App Permissions**: Specifies permissions required by the app, such as internet access, camera, storage, etc.  
* **Activities**: Declares the main activities (screens) of the app and their configuration (e.g., launcher activity).  
* **Services and Broadcast Receivers**: If the app uses services or broadcast receivers, they are defined here.  
* **Metadata and Intent Filters**: Configures app features like deep linking, themes, or Firebase integration.


#### **5\. `build.gradle` (Root)**

The root `build.gradle` file is responsible for the overall build configuration of the Android project. It sets the project-level build configurations, such as the classpath for the Android Gradle plugin, dependencies that apply to all modules, and repositories for dependencies. Key sections include:

* **Repositories**: Defines where Gradle can find dependencies, such as Maven Central or Google's repository.  
* **Dependencies**: The root build file typically includes dependencies for Gradle plugins, such as the Android plugin or Firebase plugin.  
* **Project Configuration**: Includes settings for build tools, compile SDK versions, and other global configurations.

#### **6\. `gradle.properties`**

This file is used to configure properties that apply to the entire Gradle build process. You can define custom properties and project settings that affect how the build is executed. Some common settings include:

* **Build configuration**: Set properties related to performance, such as enabling parallel builds.  
* **Signing information**: Storing keystore credentials securely (though it's recommended to keep this out of version control).

---

### **Running the App**

To run the Flutter app on your local machine or an Android device, you need to follow a few simple steps. Below is the step-by-step guide:

---

#### **1\. Prerequisites**

Before running the app, make sure you have the following set up:

**Flutter SDK**: Ensure you have Flutter installed. You can check this by running the following command in your terminal:

 	$ flutter --version

*  If you don't have Flutter installed, follow the [installation guide](https://flutter.dev/docs/get-started/install) on the official Flutter website.

* **Android Studio or Visual Studio Code**: These are the recommended IDEs for Flutter development. Install one of these if you haven’t already. You can download Android Studio from [here](https://developer.android.com/studio) or use Visual Studio Code from [here](https://code.visualstudio.com/).

* **Android Emulator or Physical Device**: To run the app, you need either an Android emulator or a connected Android device. If you're using an emulator, make sure it’s configured in Android Studio:

  * Open **Android Studio**.  
  * Go to **Tools** \> **AVD Manager** to set up an emulator if you don't have one already.  
  * Alternatively, you can use a physical Android device by enabling **Developer Options** and **USB Debugging** on your device and connecting it via USB.

---

#### **2\. Setup the Project**

1. **Clone the Repository** (if you haven’t already):

   * If this project is stored in a Git repository, clone it by running:  
     $ git clone https://github.com/PersonX-46/PriceChecker.git
     **$ cd pricechecker**

2\. **Install Dependencies**:

* In the root folder of the project (where the `pubspec.yaml` file is located), run the following command to install the required dependencies:  
  ***$ flutter pub get***

---

#### **3\. Running the App**

To run the app on an Android device, follow these steps:

* **Running on an Emulator**:

  1. Open **Android Studio**.  
  2. Launch your Android emulator from the **AVD Manager**.  
  3. In the terminal (within your project folder), run the following command to start the app:

  ***$ flutter run***

*  This will build the project and install it on the emulator.

* **Running on a Physical Device**:

  1. Connect your Android device to the computer using a USB cable.  
  2. Ensure that **Developer Options** and **USB Debugging** are enabled on your Android device.  
  3. Run the following command to check if your device is recognized:

  ***$ flutter devices***

   If your device is listed, you can then run:

     	***$ flutter run***

*  This will install and launch the app on your connected device.

---

#### **4\. Debugging and Logs**

Once the app is running, you can view logs and debug output directly in your terminal using:

***$ flutter logs***

This will display the logs from the connected device or emulator.

You can also run the app in **debug mode** with:

***$ flutter run \--debug***

In **Android Studio** or **Visual Studio Code**, you can use the built-in tools to debug and step through the code with breakpoints.

---

#### **5\. Hot Reload & Hot Restart**

* **Hot Reload**: While the app is running, you can make code changes and apply them instantly without restarting the entire app. Simply save the file, and the changes will appear in the app immediately.

* **Hot Restart**: If you need to restart the entire app (e.g., to reset the app state), you can use **hot restart** by running:

  ***$ flutter restart***

This will restart the app and apply any changes you made to the code.

---

#### **6\. Troubleshooting**

If you encounter issues while running the app, here are some common fixes:

**Flutter Doctor**: Run `flutter doctor` to check if all necessary components are properly installed.

 flutter doctor

*  This command checks the status of your Flutter installation and helps resolve any missing dependencies or configuration issues.

  **Gradle Issues**: If you experience issues related to Gradle (e.g., build failures), try running:

   	***$*** ***flutter clean***  
  ***$ flutter pub get***  
*  This will clear the build cache and fetch dependencies again.

---

### **Building the APK for Release**

Once you have set up the keystore in your `android/app/build.gradle` file (as mentioned earlier), and enabled ProGuard for code shrinking and obfuscation (already configured), you can proceed to build the release APK. Here’s how to do it:

#### **1\. Build the APK**

**Run the build command**: To generate a release APK, open your terminal in the root directory of your Flutter project and run the following command:

 	***$ flutter build apk \--release***

1.  This command will build a release version of your APK and save it to the `build/app/outputs/flutter-apk/` directory. The APK file will be named `app-release.apk`.

**Optional \- Build APK for Specific Architectures**: If you want to generate APKs specifically for different architectures (such as ARM or x86), you can use the following command:

 ***$ flutter build apk \--release \--target-platform android-arm,android-arm64***

2.  This will create APKs for both ARM and ARM64 architectures.

---

#### **2\. Locate the APK**

After the build process completes, you can find the release APK at the following path:

/build/app/outputs/flutter-apk/app-release.apk

This is the APK that you can install on an Android device or distribute for testing.

---

#### **3\. Installing the APK on Your Device**

Once you’ve generated the release APK, you can install it on an Android device. There are two ways to do this:

**Using Flutter command**: If the device is connected and set up for debugging, run the following command to install the APK:

 	***$ flutter install***

1. **Manual Installation**: Alternatively, you can manually transfer the APK to your device and open it. Make sure that **Install from Unknown Sources** is enabled in your Android device settings to allow installation of APKs outside the Play Store.
