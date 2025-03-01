# BeautySalon

## About project

eBeautySalon is a project for my University. It consists of a desktop and a mobile application. 
<br>
<br>
The desktop application is for administrators and employees. The project provides authorisation and authentification so that not everybody can use it and have an access to the unauthorised parts. In the desktop app the administrator evaluates services, news, reviews, employees, users, reservations and his profile, whereas employees evaluate parts they are in charge of.
<br>
<br>
The mobile application is for end-users. They can browse news (add a comment about it and press the like button), browse services (they can filter them, add to favorites and create a review), create reservations and make a payment, edit own profile and see their activity.
<br>
<br>
The project was made using ASP .NET Core, Flutter and SQL Server.

## Prerequisites

- [Docker Desktop installed and running](https://www.docker.com/products/docker-desktop/)
- [RabbitMQ installed](https://www.rabbitmq.com/docs/install-windows#installer)
- [Flutter installed](https://docs.flutter.dev/get-started/install/windows)
- [Visual Studio Code installed](https://code.visualstudio.com/download)
- [Android Studio installed](https://docs.flutter.dev/get-started/install/windows/mobile)

## Setting up 

- Clone the repository: https://github.com/merimas01/BeautySalon.git 
- Extract the .env file from folder "fit" to a solution folder (C:\repository-folder\BeautySalon\eBeautySalon)
- Open the solution folder in terminal (Command Prompt)
- Run a following command: docker-compose up --build (ensure your Docker Desktop is running)
- Wait until docker finish composing
- (Optional) Open Swagger at http://localhost:5145/swagger/index.html 

## Desktop App

### Setup

- Run desktop_app.exe from Debug folder in the zipped archive fit-build-2025-03-01.zip

### Credentials

*For administrator*

- `username: admin` `password: test`

*For employees*

- `username: usluznik` `password: test`

- `username: rezervacioner` `password: test`

## Mobile App

### Setup

- Open Android Studio and run Emulator
- Drag and drop the app-debug.apk file (from flutter-apk folder in the zipped archive fit-build-2025-03-01.zip) into the Emulator, in order to install the application
- Manually run the application in the Emulator

### Credentials

- `username: mobile` `password: test`

## PayPal Payment Credentials

- `email: paypal.test.rs2@gmail.com` `password: _iD{T5H&`

## Notes

- Setting up and running applications can take a few minutes, approximately about 3-5 mins.