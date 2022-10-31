export PYTHONPATH=.

alembic upgrade head

#run export PGPASSWORD="postgrespw"; psql --host="host.docker.internal" --port="49153" --username="postgres" --d="postgres" < "$PROJECTPATH/database/dump.sql"

python main.py
