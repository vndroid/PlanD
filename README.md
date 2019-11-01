# PlanD

Private Blog Docker Container Auto Deploy

## Overview

This Project includes Dockerfile and docker-compose.yaml, It can quickly deploy a blogging system, Such as Typecho or WordPress and so on.

### Step 1

Create below directory.

```bash
# mkdir -p /usr/mystack
```

> Tips: This is the project's ROOT directory.

Then create below directories.

```bash
# mkdir \
/usr/mystack/data/ \           # MySQL Physical Data
/usr/mystack/nginx/ \          # Nginx root directory
/usr/mystack/nginx/cert.d/ \   # Nginx cert directory
/usr/mystack/nginx/conf.d/ \   # Nginx conf directory (For include)
/usr/mystack/nginx/logs.d/ \   # Nginx logs directory
/usr/mystack/php/ \            # PHP config directory (Such as: php.ini)
/usr/mystack/www/ \            # Website content
```

### Step 2

Prepare required files. Please refer to the docker-compose.yaml for details.

| Path | Condition |
| --- | --- |
| /usr/mystack/nginx/nginx.conf | Required |
| /usr/mystack/php/php.ini | Required |
| /usr/mystack/www/ | Required |

> Tips: If you are using it for the first time, please make sure the folder `/usr/mystack/data` is empty.
