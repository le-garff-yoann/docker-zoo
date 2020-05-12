#!/usr/bin/env bash -e

wait_for()
{
    echo "Waiting for $1 to be up."

    i=0
    until [[ $(curl -sLo /dev/null -kw '%{http_code}' $1) == 2* ]]
    do
        sleep 1

        [[ $i -gt ${2:-300} ]] && return 1

        let i++
    done
}

docker-compose up -d --build

docker-compose exec target cat /root/.ssh/id_rsa | \
    docker exec -i "$(docker-compose ps -q rundeck)" sh -c 'cat > ~/.ssh/ansible_id_rsa'
docker-compose exec rundeck sh -c 'chmod 600 ~/.ssh/ansible_id_rsa && dos2unix ~/.ssh/ansible_id_rsa && ssh-keyscan -H target >> ~/.ssh/known_hosts'

rundeck_url=http://localhost:4440

wait_for $rundeck_url

rundeck_project="$(grep 'Rundeck-Archive-Project-Name' rundeck/project/META-INF/MANIFEST.MF | cut -d' ' -f 2)"

docker-compose exec -e RD_URL=$rundeck_url -e RD_USER=admin -e RD_PASSWORD=admin rundeck \
    sh -c "rd projects create -p $rundeck_project && rd projects archives import -p $rundeck_project --strict -racsf /tmp/project.jar && rm -f /tmp/project.jar"
