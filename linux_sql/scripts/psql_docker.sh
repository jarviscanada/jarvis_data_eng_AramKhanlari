#!/bin/sh

# Capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

# Start docker
# Make sure you understand the double pipe operator
#sudo systemctl status docker || systemctl start docker

# Check container status (try the following cmds on terminal)
docker container inspect jrvs-psql
container_status=$?

# User switch case to handle create|stop|start operations
case $cmd in
  create)
  # Check if the container is already created
  if [ $container_status -eq 0 ]; then
		echo 'Container already exists'
		exit 1
	fi

  # Check#!/bin/sh

# Capture CLI arguments
cmd=$1
db_username=$2
db_password=$3

# Start docker
# Make sure you understand the double pipe operator
#sudo systemctl status docker || systemctl start docker

# Check container status (try the following cmds on terminal)
docker container inspect $db_username
container_status=$?

# User switch case to handle create|stop|start operations
case $cmd in
  create)
  # Check if the container is already created
  if [ $container_status -eq 0 ]; then
		echo 'Container already exists'
		exit 1
	fi

  # Check # of CLI arguments
  if [ $# -ne 3 ]; then
    echo 'Create requires username and password'
    exit 1
  fi

  # Create container
	docker volume create pgdata
	export PGUSERNAME=$db_username
	export PGPASSWORD=$db_password
	# Start the container / create a container using psql image with name
	docker run --name $PGUSERNAME -e POSTGRES_USER=$PGUSERNAME -e POSTGRES_PASSWORD=$PGPASSWORD   -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:9.6-alpine
	# check if the container is created or not
	docker container ls -a -f name=$PGUSERNAME
	docker container inspect $PGUSERNAME
	container_status=$?
  # Make sure you understand what's `$?`
	exit $?
	;;

  start|stop)
  # Check instance status; exit 1 if container has not been created
  if [ $container_status -eq 1 ]; then
      echo 'Container does not exist'
      exit 1
  fi
  # Start or stop the container TODO: check if other containers are running and stop them
	docker container $cmd $db_username
	exit $?
	;;

  *)
	echo 'Illegal command'
	echo 'Commands: start|stop|create'
	exit 1
	;;
esac # of CLI arguments
  if [ $# -ne 3 ]; then
    echo 'Create requires username and password'
    exit 1
  fi

  # Create container
	docker volume create pgdata
	export PGUSERNAME=$db_username
	export PGPASSWORD=$db_password
	# Start the container / create a container using psql image with name
	docker run --name $PGUSERNAME -e POSTGRES_USER=$PGUSERNAME -e POSTGRES_PASSWORD=$PGPASSWORD   -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres:9.6-alpine
	# check if the container is created or not
	docker container ls -a -f name=$PGUSERNAME
	docker container inspect $PGUSERNAME
	container_status=$?
  # Make sure you understand what's `$?`
	exit $?
	;;

  start|stop)
  # Check instance status; exit 1 if container has not been created
  if [ $container_status -eq 1 ]; then
      echo 'Container does not exist'
      exit 1
  fi
  # Start or stop the container TODO: check if other containers are running and stop them
	docker container $cmd jrvs-psql
	exit $?
	;;

  *)
	echo 'Illegal command'
	echo 'Commands: start|stop|create'
	exit 1
	;;
esac