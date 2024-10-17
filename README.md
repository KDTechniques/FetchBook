# FetchBook - Recipe Fetching iOS App 🍰 🍜 🥗

> [!Note]
> This project was created as a Take-Home Project for **'Fetch'** company in the US to evaluate my skills in the interview process. It also covers unit tests, best coding practices, and performance enhancements, and provides a better UI/UX experience.
>
> *[Project Requirements Reference](https://d3jbb8n5wk0qxi.cloudfront.net/take-home-project.html)*


## 👨🏻‍🏫 Introduction
**FetchBook** is a simple recipe browsing app that fetches and displays recipes using a provided API. Built using Swift and SwiftUI, this app showcases MVVM architecture, efficient networking, and image caching to enhance user experience. Users can view recipes with details like name, photo, and cuisine type. The app also supports manual refresh functionality and handles various edge cases, such as empty or malformed data. 

Additionally, the app features:

- **YouTube Integration**: A floating video player that moves around the screen, providing users with seamless access to related video content.
- **Image Caching**: High priority for thumbnail images and low priority for the larger images of the same recipe, optimizing loading times and user experience.
- **Search Bar**: Users can easily search for specific recipes.
- **List Sorting Button**: Allows users to sort recipes based on their preferences.
- **Web View Navigation**: Users can navigate to the recipe blog post from the recipe list, displayed within a web view.

|Recipe List View (Main-UI)|Blog Post Web View with Youtube Player|
|-|-|
|<img src='https://github.com/KDTechniques/FetchBook/blob/main/behindTheScenesImages/Intro_1.jpg?raw=true' width='300'>|<img src='https://github.com/KDTechniques/FetchBook/blob/main/behindTheScenesImages/Intro_2.jpg?raw=true' width='300'>|


## 👨🏻‍💻 Steps to Run the App

To run the **FetchBook** app locally, follow these steps:

1. **Clone the Repository** 💽
   ```bash
   git clone https://github.com/KDTechniques/FetchBook.git
   ```
   
2. **Open the Project** 💻
- Navigate to the project directory:
```bash
cd FetchBook
```
- Open the project in Xcode by double-clicking the `.xcodeproj` file.
  
3. **Install Dependencies** 🫛
- If you are using Swift Package Manager, ensure all dependencies are resolved. This usually happens automatically when you open the project in Xcode.

4. **Run the App** 📲
- Select a simulator or connect a physical device.
- Click the Run button (or press `Cmd + R`) in Xcode to build and run the app.

5. **Explore the Features** 🤩
- Once the app is running, you can browse recipes, use the search bar, and sort the list. You can also view detailed recipe information and navigate to the recipe blog post in the web view.

6. **Use the `Debug` Tab** 🛠️
- Access the Debug tab to toggle the API endpoint to test various scenarios, including:
  - Malformed data 🚫
  - Empty data 🫙
  - Fetch all recipes 📚

- Additionally, you can clear the image cache from both memory and disk. After changing any debug options, be sure to refresh the recipe list to see the updates. ↺


## 👀 Focus Areas
In this project, I prioritized the following areas:

- User Interface 📱:
  - Focused on creating an intuitive and responsive design using SwiftUI.
  - Implemented a tabbed navigation structure to enhance both user and developer experience by effectively organizing content.
  - Designed a web view for blog post websites, allowing users to explore content within the app instead of redirecting to an external web browser.
  - Incorporated a floating YouTube player in the blog post view, enabling seamless video watching without directing users to the external YouTube app.
  - Introduced a shimmering effect to indicate loading content, preventing the UI from appearing empty while data is being fetched.

- YouTube Integration ▶️:
  - Implemented a robust YouTube video player using WKWebView, allowing users to seamlessly watch videos while navigating through recipes, enhancing overall user engagement.

- Data Management ⚙:
  - Utilized a ViewModel to manage the application's state and handle data fetching from the API, ensuring efficient and clean data flow.
  - Employed Swift concurrency to streamline asynchronous data fetching and improve performance with actors.
  - Implemented lazy loading and image caching to enhance performance, ensuring that images load efficiently and reducing memory, and network usage.
  - Developed protocols and a mock API service class, and employed dependency injection for better code structure.
  - Wrote comprehensive unit tests to ensure the reliability and maintainability of the codebase.
 
|Unit Tests|
|-|
|<img src='https://github.com/KDTechniques/FetchBook/blob/main/behindTheScenesImages/UnitTests.jpg?raw=true'>


## 🚀 Performance Optimizations
- **Lazy Loading and Image Caching**: Used a list for lazy loading of recipe images and `SDWebImageSwiftUI` for caching images. This ensures that images are only loaded when about to appear on the screen and are quickly accessible on subsequent views, reducing memory usage and unnecessary network requests.
  
- **Efficient Data Fetching**: Combined data fetching logic with Swift Concurrency to optimize the process and avoid blocking the main thread during API calls.

- **`.task` ViewModifier for Asynchronous Fetching**: Used the task modifier to initiate asynchronous data fetches directly within SwiftUI views. This allows for a seamless integration of async/await, ensuring that data fetching is efficient and happens as soon as the view appears without blocking the main thread.

- **View Extractions**: Extracted views to prevent them from being redrawn when there's a data change. This helps reduce the complexity of the main view body, promotes reusability, and improves performance by avoiding unnecessary recomputations.

- **Efficient View Composition**: Using `@ViewBuilder` makes the code more efficient by directly returning the actual views, preserving their types and avoiding unnecessary overhead caused by type-erasing them with `AnyView`.

- **Eliminate Unnecessary Dependencies**: Minimized the number of dependent views or properties that a single view relies on to prevent unnecessary updates to the entire view hierarchy.

- **Avoid Inline Filtering/Sorting in Lists**: Moved filtering and sorting logic outside of the view body to avoid recalculating it on every render. By performing these operations before passing the data to the list, the app ensures smoother performance, particularly with larger datasets.

- **Utilize `@StateObject` and `@ObservedObject` Appropriately**: Used @StateObject for managing the lifecycle of observable objects in the view and @ObservedObject for subscribing to objects created elsewhere can significantly improve memory management and performance in SwiftUI apps.

- **Stable Identifiers**: Leveraged stable identifiers (e.g., unique IDs) for recipe items in lists. This helps SwiftUI optimize view updates and animations, ensuring that the UI remains responsive when the underlying data changes.

- **Potential for Further Optimization**: I could have improved performance even further by eliminating the `SwiftUI-Shimmer` and `YouTubeiOSPlayerHelper` dependencies, reducing the overall complexity and overhead in the app.

- **Actor for API Service**: Converted the `RecipeAPIService` class to an `actor`, ensuring thread-safe operations, efficient concurrency management in asynchronous data fetching within SwiftUI views, and preventing data races and other concurrency-related issues.

- **URL Request with Caching Policies**: Implemented URL request with caching policies in fetchRecipeData. The URLRequest is initialized with a cache policy of `.reloadIgnoringCacheData` and a timeout interval of 10 seconds and got rid of HTTP caching to reduce cache usage, complying with a user requirement. This ensures efficient data fetching while minimizing unnecessary network requests and reducing the risk of stale data.

- **Non-Persistent WebView Data Store**: Configured `WKWebView` to use a `non-persistent` data store, preventing caching and reducing storage usage. This change, along with sharing the process pool, aligns with user requirements for minimized cache usage and improved performance.


## ⏰ Time Spent
I decided to invest more than 4-5 hours into this project because there was no strict deadline for the exercise. I wanted to put forth my maximum effort to create something I love. Even though this isn’t a production app, I treated it with the same seriousness and dedication as I would for any professional project. This approach reflects my strengths and a weakness of mine—I take projects very seriously and strive to deliver beautiful outcomes, whether it's a full-fledged app or a simple console application.

This habit was cultivated during lab sessions conducted by the university during my bachelor's degree. I find joy in crafting well-structured code and ensuring my projects are well-documented, as it enhances both maintainability and user experience.

I spent approximately 8.5 hours on this project. My time was allocated as follows:
- Requirements Planning: 15 min.
- Design & Prototyping: 5 min.
- Implementation: 6 hours
- Testing & Debugging: 1.5 hours
- Documentation: 1 hour


## 🧠 Trade-offs and Decisions
In this project, I made several key decisions that contributed to its overall functionality and user experience:

- I replaced HTTP URLs with HTTPS to enhance security and ensure safe data transmission between the app and the API.
- I matched model property names with the JSON recipe object attributes, adopting a consistent and easily readable naming convention. This not only simplifies the code but also improves maintainability and clarity for future developers.
- I opted not to implement alerts for error handling; instead, I displayed user-friendly error messages directly in the list view using the ContentNotAvailable view. This approach ensures users are informed without the interruption of alerts.
- Although pagination for recipe fetching could improve performance, I did not implement this feature since the API endpoint does not support it. Similarly, the lack of access to all available cuisine types from the server-side API prevented me from implementing a sort-by-cuisine feature.


## 🤒 Weakest Part of the Project
The weakest part of the project lies in the error handling of network requests. While basic error handling is implemented, there are several areas for improvement:

- **User Feedback**: Although I could have implemented alerts for error handling, I opted not to do so. Instead, I provided user-friendly feedback directly in the list view using the ContentNotAvailable view. This approach ensures that users receive clear information about any issues without the disruption of alerts.

- **Pagination**: I considered implementing pagination for recipe fetching to enhance performance and user experience. However, the current API endpoint does not support pagination, limiting my ability to load large sets of data efficiently.

- **Cuisine Sorting**: Another potential improvement could have been adding a sorting feature by cuisine type. Unfortunately, I am unable to fetch all available cuisine types from the server side with the given API endpoint, restricting this feature's implementation.


## 🫛 External Code and Dependencies
This project uses the following external libraries and dependencies:
- **SwiftUI**: For building the user interface, providing a declarative syntax for UI development.
- **SDWebImageSwiftUI**: For efficient image loading and caching, ensuring smooth performance when displaying recipe images.
- **YouTubeiOSPlayerHelper**: For integrating YouTube videos into the app.
- **WebKit**: For rendering web content within the app.
- **SwiftUI-Shimmer**: For adding a shimmering effect to indicate loading content, enhancing the user experience during data fetching.

Additionally, I utilized Copilot and ChatGPT to assist in creating some parts of the documentation and provide code suggestions for enhancing performance and structure.


## 💁🏻‍♂️ Additional Information
I've included images to show the behind-the-scenes planning of this exercise as follows:

|Once I understood the requirements and the API endpoints, I created a model, and designed the list row view|Then I documented additional features and functional improvements.|Finally, I sketched the main recipe list UI, paying close attention to typography to enhance readability and user experience.|I wrote pseudo-code for the image loading and caching mechanism using the third-party library called SDWebImageSwiftUI, but improved and simplified the functionality for better performance.|
|-|-|-|-|
|<img src='https://github.com/KDTechniques/FetchBook/blob/main/behindTheScenesImages/1.jpeg?raw=true'>|<img src='https://github.com/KDTechniques/FetchBook/blob/main/behindTheScenesImages/2.jpeg?raw=true'>|<img src='https://github.com/KDTechniques/FetchBook/blob/main/behindTheScenesImages/3.jpeg?raw=true'>|<img src='https://github.com/KDTechniques/FetchBook/blob/main/behindTheScenesImages/4.jpeg?raw=true'>|
