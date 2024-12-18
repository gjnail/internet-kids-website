# Internet Kids Website

The official website for Internet Kids audio plugins, built with Flutter Web.

## Features

- Modern, responsive design
- Interactive UI with rave mode
- Secure payment processing with Stripe
- Automatic plugin downloads after purchase
- Firebase integration for file storage

## Development

### Prerequisites

- Flutter SDK (latest stable version)
- Firebase CLI
- Node.js and npm (for Firebase hosting)

### Setup

1. Clone the repository:
```bash
git clone https://github.com/YOUR_USERNAME/internet-kids-website.git
cd internet-kids-website
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
- Create a new Firebase project
- Enable Storage and Hosting
- Update Firebase configuration in `lib/firebase_options.dart`

4. Run the development server:
```bash
flutter run -d chrome
```

### Deployment

1. Build the web app:
```bash
flutter build web
```

2. Deploy to Firebase:
```bash
firebase deploy
```

## License

Copyright © 2024 Internet Kids. All rights reserved.
