FROM php:7.4-fpm
# Arguments defined in docker-compose.yml
ARG user1=ali
ARG uid1=1003

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN echo ${user1}
RUN echo ${user1}
RUN echo "salam ${user1}"
RUN useradd -G www-data,root -u  ${uid1} -d /home/${user1}  ${user1}
RUN mkdir -p /home/$user1/.composer && \
    chown -R $user1:$user1 /home/$user1
COPY . /var/www
# Set working directory
WORKDIR /var/www

USER $user1
