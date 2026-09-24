# 🐳 Docker Compose — 2-Tier Flask + MySQL

Docker Compose is used to define and run the **Flask application and MySQL database together** using a single `docker-compose.yml` file.

## 1. 🔍 Validate Compose File

```bash
docker compose config
```

## 2. 🚀 Build & Start Containers

```bash
docker compose up -d --build
```

* `-d` → Run containers in background
* `--build` → Build the Flask image before starting

## 3. 📦 Check Containers

```bash
docker compose ps
```

## 4. 📋 Check Logs

All services:

```bash
docker compose logs
```

Flask only:

```bash
docker compose logs flask-app
```

MySQL only:

```bash
docker compose logs mysql
```

## 5. 🛑 Stop Containers

```bash
docker compose down
```

> `docker compose down` removes the containers and network, but the **named volume** remains.

## 6. 🔄 Start Again

```bash
docker compose up -d
```

## 7. 💾 MySQL Volume

The project uses a **Named Volume**:

```yaml
volumes:
  - mysql-data:/var/lib/mysql
```

Check:

```bash
docker volume ls
```

Inspect:

```bash
docker volume inspect mysql-data
```

Check the actual data files:

```bash
sudo ls -lah /var/lib/docker/volumes/mysql-data/_data
```

## 8. 🌐 Docker Network

Both Flask and MySQL use:

```yaml
networks:
  - two-tier
```

Flask connects to MySQL using the **service name**:

```yaml
MYSQL_HOST: mysql
```

So the connection is:

```text
Flask Container
      ↓
   mysql:3306
      ↓
MySQL Container
```

> Do not use `localhost` for `MYSQL_HOST`.

## 9. 🔌 Ports

```text
Flask → 5000
MySQL → 3306
```

Access Flask:

```text
http://<EC2-PUBLIC-IP>:5000
```

> In the Compose file, MySQL should normally be mapped as `"3606:3306"` if you want to access MySQL through host port `3606`.

