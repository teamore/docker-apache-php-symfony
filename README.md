Setting up a local docker container environment

# Prerequisite
You need docker and docker-compose to run the project

https://docs.docker.com/install/

https://docs.docker.com/compose/install/#install-compose

Apache service must not run locally, otherwise docker container will crash.

# Hosts
Create an example host in your `/etc/hosts` file which points to the webserver in the docker container

`127.0.0.1 polypus.lo`

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
docker exec -it polypus-app bash
su polypus
cd /var/www/html
composer install
```

# Container status
You should see at least one container running

`docker ps` 

---

You should now be able to visit http://polypus.lo:80 in your browser. If you want to run the application on another port 
than the specified one (80), please adjust the configuration accordingly.

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