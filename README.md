Setting up a local docker container environment

# Prerequisite
You need docker and docker-compose to run the project

https://docs.docker.com/install/

https://docs.docker.com/compose/install/#install-compose

Potential apache servers which have already been installed must not run locally, otherwise the provided docker container will crash.

# Adjust Settings

First things first: **Name your project** and **adjust the container settings (ports etc.) by reviewing the provided .env - file**. It contains a set of variables which will be used while building the docker containers and during the installation of additional services inside the containers via ansible (playbooks).

```
PATH_SERVICES=./services/
PROJECT_NAME=myproject
VIRTUAL_HOST=myproject.lo
HTTP_PORT=80
HTTPS_PORT=443
MYSQL_PORT=3304
PHPMA_PORT=8080
MONGODB_PORT=27021
MONGODB_EXPRESS_PORT=8081
ELASTIC_PORT=9200
KIBANA_PORT=5601
MAILDEV_PORT=81
COMPOSE_CONVERT_WINDOWS_PATHS=1
COMPOSE_PATH_SEPARATOR=:
COMPOSE_FORCE_WINDOWS_HOST=false
PHP_VERSION=8.2
```



# Hosts
Create an example host in your `/etc/hosts` file which points to the webserver in the docker container

`127.0.0.1 myproject.lo`

## Configuration
If your Dockerfiles reside at another location or if you want the application or associated containers to listen 
to other ports (e.g. because the default ports are already in use by other applications or running docker containers),
you can edit the respective configuration directive in the `.env`-file accordingly.

By changing the configuration parameters in the .env-file, can also pick a PHP version other than the preselected 
one (php8.1). 

If you change the path settings for `PATH_SERVICES`, please make sure that you 
**add a trailing forward slash** to the configured path. 

# Build and run
Switch to the root path in your repository and run docker-compose

```
# build
docker-compose build

# run [with -d for detach]
docker-compose up [-d]
```

# Composer
Log into Web container and run composer install to get dependencies

```bash
docker exec -it myproject-app bash
su myproject
cd /var/www/html
composer install
```

# Container status
You should see at least one container running

`docker ps` 

---

Unless the port settings have been altered in the .env - configuration file, you can reach the containers by calling localhost with their respective ports:

* frontend: http://localhost:80 (secure connection: https://localhost:443)
* phpmyadmin: http://localhost:8080
* mongo express: http://localhost:8081
* kibana (elastic): http://localhost:5601
* elastic: http://localhost:9200
* maildev: http://localhost:81

If you want the application components to be run on different ports, please adjust the configuration accordingly by editing .env.

# Xdebug
To use Xdebug add the role xdebug to your microservice.

In PHPStorm go to Settings->Languages & Frameworks->PHP->Servers

Add Server:
```
Name: microservice.lo
Host: microservice.lo
Port: 80
Debugger: Xdebug
```
Hostname = Servicename + .lo

Enable path mappings -> Select the root of your local project and set the absolute server path to `/var/www/html`.

Save the settings.

Don't forget to make PHPStorm listen to debug sessions by clicking on the little phone in the top right of PHPStorm. 

# Troubleshoot
If composer install fails to complete with an 137 exit code, stop the container and re-run ``docker compose up``. If the
problem recurs, try to increase the memory limit via the docker preferences (under Resources/memory). Once composer install was successfully completed, you can lower the memory limit back to its original
setting (usually 2GB).
