ARG user1=ali
ARG uid1=1003
FROM  php:7.4-fpm

# Arguments defined in docker-compose.yml
ARG user1
ARG uid1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nginx

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
COPY . /var/www
# Set working directory
WORKDIR /var/www
RUN mkdir /var/www/storage/logs
RUN chown www-data storage/logs/
RUN php artisan key:generate
RUN chown www-data /var/www/storage/framework/views
CMD service nginx start



