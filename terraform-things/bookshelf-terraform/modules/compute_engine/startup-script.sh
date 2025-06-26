#!/bin/bash
set -e
set -x

sleep 10

sudo -u amanpm108 bash <<'EOF'
set -e
set -x

cd /home/amanpm108/projects/getting-started-python/7-gce/

cloud_sql_proxy -dir=/cloudsql -instances=gcp-project-terraform-462411:us-central1:bookshelf-sql &

sleep 5
export PATH="/home/amanpm108/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv activate myenv



fetch_metadata() {   curl -sf -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/$1" 
} 
# Fetch metadata 
PROJECT_ID=$(fetch_metadata PROJECT_ID) 
CLOUDSQL_USER=$(fetch_metadata CLOUDSQL_USER) 
CLOUDSQL_PASSWORD=$(fetch_metadata CLOUDSQL_PASSWORD) 
CLOUDSQL_DATABASE=$(fetch_metadata CLOUDSQL_DATABASE) 
CLOUDSQL_CONNECTION_NAME=$(fetch_metadata CLOUDSQL_CONNECTION_NAME) 
CLOUD_STORAGE_BUCKET=$(fetch_metadata CLOUD_STORAGE_BUCKET) 
GOOGLE_OAUTH2_CLIENT_ID=$(fetch_metadata GOOGLE_OAUTH2_CLIENT_ID) 
GOOGLE_OAUTH2_CLIENT_SECRET=$(fetch_metadata GOOGLE_OAUTH2_CLIENT_SECRET) 
DATA_BACKEND=$(fetch_metadata DATA_BACKEND) 


CONFIG_FILE="/home/amanpm108/projects/getting-started-python/7-gce/config.py"
sed -i "s|PROJECT_ID = '.*'|PROJECT_ID = '${PROJECT_ID}'|g" "$CONFIG_FILE"
sed -i "s|CLOUDSQL_USER = '.*'|CLOUDSQL_USER = '${CLOUDSQL_USER}'|g" "$CONFIG_FILE"
sed -i "s|CLOUDSQL_PASSWORD = '.*'|CLOUDSQL_PASSWORD = '${CLOUDSQL_PASSWORD}'|g" "$CONFIG_FILE"
sed -i "s|CLOUDSQL_DATABASE = '.*'|CLOUDSQL_DATABASE = '${CLOUDSQL_DATABASE}'|g" "$CONFIG_FILE"
sed -i "s|CLOUDSQL_CONNECTION_NAME = '.*'|CLOUDSQL_CONNECTION_NAME = '${CLOUDSQL_CONNECTION_NAME}'|g" "$CONFIG_FILE"
sed -i "s|CLOUD_STORAGE_BUCKET = '.*'|CLOUD_STORAGE_BUCKET = '${CLOUD_STORAGE_BUCKET}'|g" "$CONFIG_FILE"
sed -i "s|GOOGLE_OAUTH2_CLIENT_ID = .*|GOOGLE_OAUTH2_CLIENT_ID = '${GOOGLE_OAUTH2_CLIENT_ID}'|g" "$CONFIG_FILE"
sed -i "s|GOOGLE_OAUTH2_CLIENT_SECRET = '.*'|GOOGLE_OAUTH2_CLIENT_SECRET = '${GOOGLE_OAUTH2_CLIENT_SECRET}'|g" "$CONFIG_FILE"
sed -i "s|DATA_BACKEND = '.*'|DATA_BACKEND = '${DATA_BACKEND}'|g" "$CONFIG_FILE"

python bookshelf/model_cloudsql.py
nohup gunicorn -b 0.0.0.0:8080 main:app > "$HOME/app.log" 2>&1 &

sleep 3
pgrep -f gunicorn > /dev/null || { tail "$HOME/app.log"; exit 1; }
EOF
