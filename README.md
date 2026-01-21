# About this Repo

Preconfigured PHP + Apache Docker image.

This is designed to be like a shared hosting environment. You can easily migrate your PHP application (e.g. WordPress, Typecho, Piwik, etc.) to it directly without changing anything. (However, you may need your own database, just like the one provided by shared hosting.)

Runtime:
 * Apache 2
 * PHP

Preinstalled:
 * some useful Apache modules
 * some useful PHP modules

## Usage

The container will use `/var/www/html` as wwwroot. So assume your actually wwwroot is `/path/to/your/wwwroot`, use the following command:

```shell
docker run --name my_website -itP --rm -v /path/to/your/wwwroot:/var/www/html jamesits/docker-easyphp:latest
```

Then you can access your website at port 80.

## Caveats

### Privileges

Processes run as www-root(uid=33):www-root(gid=33) in container, and probably outside container (if not configured explicitly).
