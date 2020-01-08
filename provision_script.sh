#!/bin/bash

# 1. Install base packages
apt-get update
apt-get install -y bats jq mc python3-pip sqlite libxml2-utils
update-alternatives --install /usr/bin/python python /usr/bin/python3 1
pip3 install django
django-admin --version

# 2. Create new Django project / app
django-admin startproject website
cd website
./manage.py  startapp app

# 3. Configurations on website
cd website
# 3.1. settings.py
sed -ri "s/'django.contrib.staticfiles'/'django.contrib.staticfiles',\n    'app'/g" settings.py
# 3.2. website urls.py
sed -ri "s/urlpatterns = \[/urlpatterns = \[\n    path('app\/', include('app.urls')),/g" urls.py
sed -ri "s/from django.urls import path/from django.urls import path\nfrom django.conf.urls import include/g" urls.py
# 3.3. Copy website views.py
rsync -av  /vagrant/website/* .

# 4. Configurations on app
cd ../app
rsync -av /vagrant/app/ .

# 5. Migrate
cd ..
./manage.py makemigrations app
./manage.py migrate
./manage.py loaddata app/app.json
nohup ./manage.py runserver > log.txt &
