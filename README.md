# conference.mlinpl.org

Repository with the code of conference.mlinpl.org website.

## Running locally with Docker

### Prerequsites
Have [Docker](https://www.docker.com/products/docker-desktop/) installed for your operating system. Ensure the Docker daemon is running.

### Building the image
Run the following command
```
docker build -t conference.mlinpl.org .
```

### Running the container
Run the following command:

Windows / Linux / Mac:
```
docker run --name conference-mlinpl-container --rm -p 4000:4000 conference.mlinpl.org
```

### Stopping the container
Run the following command:

Windows / Linux / Mac:
```
docker stop conference-mlinpl-container
```

You can also run these commands from NPM SCRIPTS panel if you are using VS Code

### Accesing the site
Access the site at [http://localhost:4000](http://0.0.0.0:4000/www-dev/)
