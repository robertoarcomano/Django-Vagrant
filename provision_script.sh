#!/bin/bash

# 1. Install base packages
apt-get update
apt-get install -y bats jq mc python3-pip sqlite
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
./manage server

exit
# 3. Activate repository and install elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
add-apt-repository "deb https://artifacts.elastic.co/packages/7.x/apt stable main"
apt-get update
apt-get install -y elasticsearch logstash kibana

# 4. Configure ELK
# 4.1. Configure Elasticsearch
echo "
network.host: 0.0.0.0
cluster.name: elkcluster
node.name: \"elkhost\"
cluster.initial_master_nodes:
  - elkhost
" >> /etc/elasticsearch/elasticsearch.yml

# 4.2. Configure Logstash
cp /vagrant/document.conf /etc/logstash/conf.d/

# 4.3. Configure Kibana
echo "
server.host: \"0.0.0.0\"
" >> /etc/kibana/kibana.yml

# 5. Enable and start Elasticsearch logstash
systemctl enable elasticsearch.service
systemctl start elasticsearch.service
systemctl enable logstash.service
systemctl start logstash.service
systemctl enable kibana
systemctl start kibana
