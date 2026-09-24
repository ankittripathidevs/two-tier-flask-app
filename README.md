# 🐳 2-Tier Flask + MySQL — Docker Notes

A simple 2-tier application where a **Flask backend** connects to a **MySQL database** using Docker Network, Named Volume, Docker Compose, and Docker Hub.

## Tech Stack

* Python 3.9
* Flask
* MySQL
* Docker
* Docker Network
* Docker Named Volume
* Docker Compose
* Docker Hub
* AWS EC2

---

# 📁 Project Structure

```text
01_two-tier-flask-app/
├── Dockerfile
├── docker-compose.yml
├── README.md
├── app.py
├── message.sql
├── requirements.txt
└── templates/
```

---

# 🏗️ Architecture

```text
                 User
                  │
                  ▼
             EC2 :5000
                  │
                  ▼
          ┌───────────────┐
          │ Flask Container│
          └───────┬───────┘
                  │
          Docker Network
             two-tier
                  │
                  ▼
          ┌───────────────┐
          │ MySQL Container│
          └───────┬───────┘
                  │
             Named Volume
              mysql-data
                  │
                  ▼
           Persistent Data
```

---

# 1. 🌐 Docker Network

Create a custom network:

```bash
docker network create two-tier
```

Check networks:

```bash
docker network ls
```

Inspect network:

```bash
docker network inspect two-tier
```

Containers connected to the same Docker network can communicate using **container/service names**.

Example:

```text
Flask → mysql-container:3306
```

> Do not use `localhost` for connecting from Flask to MySQL. Inside a container, `localhost` means the same container.

---

# 2. 💾 Docker Named Volume

Create volume:

```bash
docker volume create mysql-data
```

Check volumes:

```bash
docker volume ls
```

Inspect:

```bash
docker volume inspect mysql-data
```

View data:

```bash
sudo ls -lah /var/lib/docker/volumes/mysql-data/_data
```

### Named Volume

```bash
-v mysql-data:/var/lib/mysql
```

Docker manages the storage location.

### Bind Mount

```bash
-v ./mysql-data:/var/lib/mysql
```

You provide the host storage location.

### Why use a volume?

```text
MySQL Container
      ↓
mysql-data
      ↓
Persistent Database Data
```

The data remains even if the MySQL container is removed, as long as the volume is not deleted.

---

# 3. 🍃 Run MySQL Container

```bash
docker run -d \
  --name mysql-container \
  --network=two-tier \
  -e MYSQL_ROOT_PASSWORD=root \
  -e MYSQL_DATABASE=devops \
  -v mysql-data:/var/lib/mysql \
  -p 3306:3306 \
  mysql:latest
```

Check:

```bash
docker ps
```

---

# 4. 🐍 Build Flask Image

```bash
docker build -t flaskapp .
```

Check images:

```bash
docker images
```

---

# 5. 🚀 Run Flask Container

```bash
docker run -d \
  --name flask-container \
  --network=two-tier \
  -e MYSQL_HOST=mysql-container \
  -e MYSQL_USER=root \
  -e MYSQL_PASSWORD=root \
  -e MYSQL_DB=devops \
  -p 5000:5000 \
  flaskapp:latest
```

Important:

```text
MYSQL_HOST=mysql-container
```

Because both containers are connected to:

```text
two-tier
```

---

# 6. 🔍 Check Containers

```bash
docker ps
```

Check network:

```bash
docker network inspect two-tier
```

Both should appear:

```text
flask-container
mysql-container
```

---

# 7. 🗄️ Check MySQL Data

Enter MySQL:

```bash
docker exec -it mysql-container mysql -u root -p
```

Password:

```text
root
```

Run:

```sql
SHOW DATABASES;

USE devops;

SHOW TABLES;

SELECT * FROM messages;
```

---

# 8. 🌐 Access Flask Application

Local:

```text
http://localhost:5000
```

AWS EC2:

```text
http://<EC2-PUBLIC-IP>:5000
```

Make sure **port 5000** is allowed in the EC2 Security Group.

---

# 9. 🐳 Docker Compose

Docker Compose allows multiple containers to be managed from one file.

### Validate Compose

```bash
docker compose config
```

### Build & Start

```bash
docker compose up -d --build
```

* `-d` → Run in background
* `--build` → Build images before starting

### Check Services

```bash
docker compose ps
```

### Logs

All services:

```bash
docker compose logs
```

Flask:

```bash
docker compose logs flask-app
```

MySQL:

```bash
docker compose logs mysql
```

### Stop

```bash
docker compose down
```

> `docker compose down` removes containers and the Compose network, but normally keeps named volumes.

### Start Again

```bash
docker compose up -d
```

---

# 10. 🔗 Compose Network & Service Name

Example:

```yaml
services:

  flask-app:
    image: ankittripathidocker/two-tier-backend:latest
    environment:
      MYSQL_HOST: mysql
      MYSQL_USER: root
      MYSQL_PASSWORD: root
      MYSQL_DB: devops
    networks:
      - two-tier

  mysql:
    image: mysql:latest
    networks:
      - two-tier

networks:
  two-tier:
```

Flask connects to:

```text
mysql:3306
```

Here:

```text
mysql = Compose service name
```

> In Docker Compose, use the **service name** for container-to-container communication.

---

# 11. 🔌 Port Mapping

General format:

```text
HOST_PORT:CONTAINER_PORT
```

Example:

```yaml
ports:
  - "5000:5000"
```

Means:

```text
EC2:5000 → Flask:5000
```

MySQL:

```yaml
ports:
  - "3306:3306"
```

If you want host port `3606`:

```yaml
ports:
  - "3606:3306"
```

This means:

```text
EC2:3606 → MySQL Container:3306
```

The application should still normally connect to MySQL on:

```text
mysql:3306
```

---

# 12. 💾 Compose Named Volume

Example:

```yaml
volumes:
  - mysql-data:/var/lib/mysql
```

Define the volume:

```yaml
volumes:
  mysql-data:
```

Check:

```bash
docker volume ls
```

Inspect:

```bash
docker volume inspect mysql-data
```

---

# 13. 📦 Docker Hub / Docker Registry

A Docker Registry stores and distributes Docker images.

Basic workflow:

```text
Build
  ↓
Tag
  ↓
Push
  ↓
Docker Hub
  ↓
Pull
  ↓
Deploy
```

---

## Login

```bash
docker login
```

Check images:

```bash
docker images
```

---

# 14. 🏷️ Tag Image

Docker Hub format:

```text
USERNAME/REPOSITORY:TAG
```

Example:

```bash
docker image tag flaskapp:latest \
  ankittripathidocker/two-tier-backend:latest
```

Check:

```bash
docker images
```

> Tagging creates another reference to the same image; it does not create a second copy of the image layers.

---

# 15. ⬆️ Push Image

```bash
docker push ankittripathidocker/two-tier-backend:latest
```

The image is now available in Docker Hub.

---

# 16. ⬇️ Pull Image

On another machine:

```bash
docker pull ankittripathidocker/two-tier-backend:latest
```

Then run the image or use it with Docker Compose.

---

# 17. 🐳 Use Docker Hub Image in Compose

### Build locally

```yaml
flask-app:
  build:
    context: .
```

### Use Docker Hub

```yaml
flask-app:
  image: ankittripathidocker/two-tier-backend:latest
```

Then:

```bash
docker compose up -d
```

Compose will pull/use the image instead of building it locally.

---

# 18. 🔄 CI/CD Concept

Docker Hub becomes useful in CI/CD:

```text
Developer
    ↓
GitHub
    ↓
Jenkins / GitHub Actions
    ↓
Build Docker Image
    ↓
Push to Docker Hub
    ↓
EC2
    ↓
Pull Image
    ↓
Run Container
```

### Main Benefit

Build the image **once** and deploy the same image across different environments.

```text
Build Once
    ↓
Test
    ↓
Push
    ↓
Deploy Same Image
```

---

# 📌 Important Commands

## Docker

```bash
docker images
docker ps
docker build -t flaskapp .
docker run -d ...
docker exec -it mysql-container mysql -u root -p
```

## Network

```bash
docker network create two-tier
docker network ls
docker network inspect two-tier
```

## Volume

```bash
docker volume create mysql-data
docker volume ls
docker volume inspect mysql-data
```

## Compose

```bash
docker compose config
docker compose up -d --build
docker compose ps
docker compose logs
docker compose down
```

## Docker Hub

```bash
docker login
docker images
docker image tag IMAGE USERNAME/REPOSITORY:TAG
docker push USERNAME/REPOSITORY:TAG
docker pull USERNAME/REPOSITORY:TAG
```

---

# 🎯 Key Concepts

| Concept        | Purpose                                |
| -------------- | -------------------------------------- |
| Docker Network | Container-to-container communication   |
| Named Volume   | Persistent data storage                |
| Docker Compose | Manage multiple containers together    |
| Docker Hub     | Store and distribute images            |
| Service Name   | DNS name used between Compose services |
| Port Mapping   | Expose container services to the host  |
| Docker Image   | Application package/template           |
| Container      | Running instance of an image           |

### Remember

```text
Network  → Communication
Volume   → Persistence
Compose  → Container Management
Registry → Image Storage
```
