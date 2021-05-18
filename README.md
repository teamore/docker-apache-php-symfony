Setting up a local docker container environment

# Prerequisite
You need docker and docker-compose to run the project

https://docs.docker.com/install/

https://docs.docker.com/compose/install/#install-compose

Apache service must not run locally, otherwise docker container will crash.

# Hosts
Create an example host in your `/etc/hosts` file which points to the webserver in the docker container

`127.0.0.1 butterflies.lo`

## Docker Repository at another location
If your Docker repository is at another location edit the `PATH_MICROSERVICES` in `.env` accordingly.
Make sure that you **add a trailing forward slash** to the path and locally exclude these files from committing.

Make sure you locally (your IDE, etc.) exclude these files from committing.

**Don't** edit the public `.gitignore`!


# Configure RabbitMQ definitions
See the dist file to create your own definitions.json

```json
{
 "users": [
  {
   "name": "[YOUR_USER]",
   "password": "[YOUR_PASSWORD]",
   "hashing_algorithm": "rabbit_password_hashing_sha256",
   "tags": "administrator"
  }
 ],
 "vhosts": [
  {
   "name": "[YOUR_VIRTUAL_HOST]]"
  }
 ],
 "permissions": [
  {
   "user": "[YOUR_USER]",
   "vhost": "[YOUR_VIRTUAL_HOST]",
   "configure": ".*",
   "write": ".*",
   "read": ".*"
  }
 ],
 "parameters": [],
 "policies": [],
 "queues": [],
 "exchanges": [],
 "bindings": []
}
```

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
docker exec -it butterflies-backend bash
su butterflies
cd /var/www/html/butterflies
composer install
```

# Container status
You should see at least one container running

`docker ps` 

---

You should now be able to visit http://butterflies.lo in your browser.  
The frontend available under http://butterflies.lo:4200  
RabbitMq Managment should be available at http://localhost:15672  

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