# BeautySalon

## About project

eBeautySalon is a project for my University. It consists of a desktop and a mobile application. 
<br>
Desktop application is for administrator and employees (). The project provides authorisation and authentification so that not everybody can use it and have an access to the unauthorised parts. In desktop app administrator evaluates services, news, reviews, employees, users, reservations and its profile.
<br>
Mobile application is for end-users. They can browse news (add a comment about it and press a like button), browse services (they can filter them and create a review), create reservations and make a payment, edit own profile and see their activity.
<br>
The project was made using ASP .NET Core, Flutter and SQL Server.

## Prerequisites

- [Docker Desktop installed and running](https://www.docker.com/products/docker-desktop/)
- [RabbitMQ installed](https://www.rabbitmq.com/docs/install-windows#installer)
- [Flutter installed](https://docs.flutter.dev/get-started/install/windows)
- [Visual Studio Code installed](https://code.visualstudio.com/download)
- [Android Studio installed](https://docs.flutter.dev/get-started/install/windows/mobile)

## Setting up 

- Clone the repository
- Open a solution folder in CMD
- Run a following command: docker-compose up --build
- Wait until docker finish composing

## Desktop App

### Set up

1. Open desktop_app directory in Visual Studio Code (VSC)
2. Run the following commands in VSC terminal:

- flutter clean
- flutter pub get
- flutter run -d windows

### Credentials:

*For administrator*

- username: admin
- password: test

*For employees*

- username: usluznik
- password: test

- username: rezervacioner
- password: test

## Mobile App

### Set up

1. Open mobile_app directory in Visual Studio Code (VSC)
2. Open Android Studio and run Emulator
3. Run the following commands in VSC terminal:

- flutter clean
- flutter pub get
- flutter run

### Credentials:

- username: mobile
- password: test

## Notes

- Setting Up and Running applications can take a few minutes, approximately about 3-5 mins.