# FetchBook - Recipe Fetching iOS App 🍰 🍜 🥗

> [!Note]
> This project was created as a take-home project for **'Fetch'** company in the US to evaluate my skills in the interview process. It also covers unit tests, best coding practices, performance enhancements, and provides a better UI/UX experience.

## 👨🏻‍🏫 Introduction
**FetchBook** is a simple recipe browsing app that fetches and displays recipes using a provided API. Built using Swift and SwiftUI, this app showcases clean architecture, efficient networking, and image caching to enhance user experience. Users can view recipes with details like name, photo, and cuisine type. The app also supports manual refresh functionality and handles various edge cases, such as empty or malformed data. 

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
  - Employed Swift concurrency to streamline asynchronous data fetching and improve performance.
  - Implemented lazy loading and image caching to enhance performance, ensuring that images load efficiently and reducing memory, and network usage.
  - Developed protocols, a mock API service class, and employed dependency injection for better code structure.
  - Wrote comprehensive unit tests to ensure the reliability and maintainability of the codebase.
 
|Unit Tests|
|-|
|<img src='https://github.com/KDTechniques/FetchBook/blob/main/behindTheScenesImages/UnitTests.jpg?raw=true'>

## ⏰ Time Spent
I decided to invest more than 4-5 hours into this project because there was no strict deadline for the exercise. I wanted to put forth my maximum effort to create something I love. Even though this isn’t a production app, I treated it with the same level of seriousness and dedication as I would for any professional project. This approach reflects both a strength and a weakness of mine—I take projects very seriously and strive to deliver beautiful outcomes, regardless of whether it's a full-fledged app or a simple console application.

This habit was cultivated during my bachelor’s degree during lab sessions conducted by the university. I find joy in crafting well-structured code and ensuring my projects are well-documented, as it enhances both maintainability and user experience.

I spent approximately 17.5 hours on this project. My time was allocated as follows:
- Requiremnents Planning: 1 hour
- Design & Prototyping: 30min
- Implementation: 12 hours
- Testing & Debugging: 3 hours
- Documentation: 1 hour

## 🧠 Trade-offs and Decisions
In this project, I made several key decisions that contributed to its overall functionality and user experience:

- I replaced HTTP URLs with HTTPS to enhance security and ensure safe data transmission between the app and the API.
- I matched model property names with the JSON recipe object attributes, adopting a consistent and easily readable naming convention. This not only simplifies the code but also improves maintainability and clarity for future developers.
- I opted not to implement alerts for error handling; instead, I displayed user-friendly error messages directly in the list view using the ContentNotAvailable view. This approach ensures users are informed without the interruption of alerts.
- Although pagination for recipe fetching could improve performance, I did not implement this feature since the API endpoint does not support it. Similarly, the lack of access to all available cuisine types from the server-side API prevented me from implementing a sort-by-cuisine feature.

## 🤒 Weakest Part of the Project
The weakest part of the project lies in the error handling for network requests. While basic error handling is implemented, there are several areas for improvement:

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

## 💁🏻‍♂️ Additional Information
I've included images to show the behind-the-scenes planning of this exercise as follows:

|Once I understood the requirements and the API endpoints, I created a model, designed the list row view|Then I documented additional features and functional improvements.|Finally, I sketched the main recipe list UI, paying close attention to typography to enhance readability and user experience.|I wrote pseudo code for the image loading and caching mechanism using the third-party library called SDWebImageSwiftUI, but improved and simplified the functionality for better performance.|
|-|-|-|-|
|<img src='https://github.com/KDTechniques/FetchBook/blob/main/behindTheScenesImages/1.jpeg?raw=true'>|<img src='https://github.com/KDTechniques/FetchBook/blob/main/behindTheScenesImages/2.jpeg?raw=true'>|<img src='https://github.com/KDTechniques/FetchBook/blob/main/behindTheScenesImages/3.jpeg?raw=true'>|<img src='https://github.com/KDTechniques/FetchBook/blob/main/behindTheScenesImages/4.jpeg?raw=true'>|
