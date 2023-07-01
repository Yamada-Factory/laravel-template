#!/bin/bash

set -e

# DBコンテナが起動するのを待つ
until nc -z -v -w30 $DB_HOST $DB_PORT
do
  echo "Waiting for database connection..."
  sleep 5
done

# Laravelの依存パッケージをインストール
composer install --no-interaction --optimize-autoloader

# キャッシュやログディレクトリのパーミッションを設定
chown -R www-data:www-data storage bootstrap/cache

# .envファイルが存在しない場合は、コピーして生成
if [ ! -f .env ]; then
  cp .env.example .env
fi

# アプリケーションキーを生成
php artisan key:generate --ansi

# データベースのマイグレーションを実行
php artisan migrate --force

# キャッシュのクリア
php artisan cache:clear

php-fpm
