# BeautySalon

## About project

eBeautySalon is a project for my University. It consists of a desktop and a mobile application. 
<br>
<br>
The desktop application is for administrators and employees. The project provides authorisation and authentification so that not everybody can use it and have an access to the unauthorised parts. In the desktop app the administrator evaluates services, news, reviews, employees, users, reservations and his profile, whereas employees evaluate parts they are in charge of.
<br>
<br>
The mobile application is for end-users. They can browse news (add a comment about it and press the like button), browse services (they can filter them and create a review), create reservations and make a payment, edit own profile and see their activity.
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
- Open a solution folder in terminal (Command Prompt)
- Run a following command: docker-compose up --build
- Wait until docker finish composing
- Open Swagger at http://localhost:5145/swagger/index.html 

## Desktop App

### Setup

1. Open desktop_app directory in Visual Studio Code (VSC)
2. Run the following commands in VSC terminal:

- flutter clean
- flutter pub get
- flutter run -d windows

### Credentials

*For administrator*

- `username: admin` `password: test`

*For employees*

- `username: usluznik` `password: test`

- `username: rezervacioner` `password: test`

## Mobile App

### Setup

1. Open mobile_app directory in Visual Studio Code (VSC)
2. Open Android Studio and run Emulator
3. Run the following commands in VSC terminal:

- flutter clean
- flutter pub get
- flutter run

### Credentials

- `username: mobile` `password: test`

## PayPal Payment Credentials

- `email: paypal.test.rs2@gmail.com` `password: _iD{T5H&`

## Notes

- Setting Up and running applications can take a few minutes, approximately about 3-5 mins.