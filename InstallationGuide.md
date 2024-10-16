# Installation Guide

## Backend (Laravel)
1. Clone the repository:
   ```bash
   git clone https://github.com/REChain-Network-Solutions/PoSPro-.git
   cd PoSPro-backend
   ```

2. Install dependencies:
   ```bash
   composer install
   ```

3. Set up the `.env` file:
   - Copy `.env.example` to `.env`
   - Configure your database and other environment settings

4. Run database migrations:
   ```bash
   php artisan migrate
   ```

5. Serve the application:
   ```bash
   php artisan serve
   ```

## Frontend (Flutter)
1. Navigate to the Flutter frontend directory:
   ```bash
   cd PoSPro-frontend
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```
