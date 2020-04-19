all: run

clean:
	rm -rf ../.venv && rm -rf *.egg-info && rm -rf dist && rm -rf *.log*

venv:
	cd ..;pipenv --three --bare install -e simpleq

run: venv
	export FLASK_APP=simpleq; SIMPLEQ_SETTINGS=../settings.cfg; pipenv --bare run python -m simpleq

test: venv
	cd ..; SIMPLEQ_SETTINGS=../settings.cfg pipenv --bare run python -m unittest discover -s tests

sdist: venv test
	rm -rf dist; pipenv --bare run python setup.py sdist

build-container: sdist
	cd dist;tar -xvf simpleq-$(version).tar.gz; \
	mv simpleq-$(version) simpleq; \
	cd ..; docker build . -t simpleq:$(version)
