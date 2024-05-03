# Дипломная работа по профессии «Системный администратор» - `Согонов Алексей`"

### Задание 1
```
1. Разворачиваем структуру с помщью terrafrom
2. На zabbix сервере устанавливаем postgresql и создаем пользователя с базой данных:

sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
sudo wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install postgresql
sudo systemctl start postgresql.service

sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix zabbix

3. На master устанавливаем ansible:

sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible

4. скачиваем и распаковываем образец сайта

sudo curl -L https://github.com/do-community/html_demo_site/archive/refs/heads/main.zip -o html_demo.zip
sudo apt install unzip
sudo unzip html_demo.zip

5. Запускаем ansible playbook ansible-playbook all.yml

сайт доступен через http://158.160.163.148/
zabbix http://178.154.203.133:8080/
kibana http://158.160.127.8:5601/

```
![Название скриншота 1](https://github.com/SogonovAN/diplom/blob/main/img/kibana.JPG)`

![Название скриншота 1](https://github.com/SogonovAN/diplom/blob/main/img/zabbix.JPG)`

---

