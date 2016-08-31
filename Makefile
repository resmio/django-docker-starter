
.PHONY: manage.py

help:
	@echo "dbshell                  Enter a SQL shell"
	@echo "help                     This help message"
	@echo "manage.py                Execute manage.py command. E.g. "make manage.py migrate""
	@echo "pyshell                  Enter local django shell"
	@echo "rebuild                  (Re)build docker web container"
	@echo "rebuild-all              (Re)build all docker containers"
	@echo "shell                    Enter local bash shell in web container"
	@echo "start                    Startup all docker containers - see the logs"
	@echo "stop                     Stop all docker-compose containers"
	@echo "test                     Run some tests"
	@echo 'freeze-requirements      Update your freezed requirements file, do this after changes in requirements.in'
	@echo '                         Use `make freeze-requirements extra=--upgrade` to upgrade already freezed dependencies'

rebuild:
	# docker-compose build workers
	docker-compose build web

rebuild-all:
	docker-compose down
	docker-compose rm --all
	docker-compose build

start:
	docker-compose up

stop:
	docker-compose stop

up:
	make start

manage.py:
	docker-compose run web python manage.py $(filter-out $@,$(MAKECMDGOALS))

shell:
	docker-compose run web bash

pyshell:
	docker-compose run web sh -c "PYTHONSTARTUP=.pythonrc.py python manage.py shell"

dbshell:
	docker-compose run web sh -c "apt-get install postgresql-client -y && PGPASSWORD=abcdEF123456 python manage.py dbshell"

test:
	pre-commit run --all-files
	docker-compose run web  python manage.py test

freeze-requirements:
	pip-compile requirements.in --output-file docker/python/requirements.txt ${extra}
	@echo ''
	@echo ''
	@echo '    ======================================================================'
	@echo '    = Your requirements.in is freezed at docker/python/requirements.txt ='
	@echo '    ======================================================================'

# needed for manage.py but does hide command not found errors
%:
	@:
