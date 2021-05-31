ARG user1=ali
ARG uid1=1003
FROM php:7.4-apache
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
    unzip
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY start-apache /usr/local/bin
RUN chmod +x /usr/local/bin/start-apache
RUN a2enmod rewrite

# Copy application source
COPY . /var/www/
RUN chown -R www-data:www-data /var/www

CMD ["start-apache"]

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u  ${uid1} -d /home/${user1}  ${user1}
RUN mkdir -p /home/$user1/.composer && \
    chown -R $user1:$user1 /home/$user1

# Set working directory
WORKDIR /var/www
EXPOSE 80
USER $user1
